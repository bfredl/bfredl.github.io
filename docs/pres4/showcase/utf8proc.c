/* return whether there is a grapheme break between boundclasses lbc and tbc
   (according to the definition of extended grapheme clusters)

  Rule numbering refers to TR29 Version 29 (Unicode 9.0.0):
  http://www.unicode.org/reports/tr29/tr29-29.html

  CAVEATS:
   Please note that evaluation of GB10 (grapheme breaks between emoji zwj sequences)
   and GB 12/13 (regional indicator code points) require knowledge of previous characters
   and are thus not handled by this function. This may result in an incorrect break before
   an E_Modifier class codepoint and an incorrectly missing break between two
   REGIONAL_INDICATOR class code points if such support does not exist in the caller.

   See the special support in grapheme_break_extended, for required bookkeeping by the caller.
*/
static utf8proc_bool grapheme_break_simple(int lbc, int tbc) {
  return
    (lbc == UTF8PROC_BOUNDCLASS_START) ? true :       // GB1
    (lbc == UTF8PROC_BOUNDCLASS_CR &&                 // GB3
     tbc == UTF8PROC_BOUNDCLASS_LF) ? false :         // ---
    (lbc >= UTF8PROC_BOUNDCLASS_CR && lbc <= UTF8PROC_BOUNDCLASS_CONTROL) ? true :  // GB4
    (tbc >= UTF8PROC_BOUNDCLASS_CR && tbc <= UTF8PROC_BOUNDCLASS_CONTROL) ? true :  // GB5
    (lbc == UTF8PROC_BOUNDCLASS_L &&                  // GB6
     (tbc == UTF8PROC_BOUNDCLASS_L ||                 // ---
      tbc == UTF8PROC_BOUNDCLASS_V ||                 // ---
      tbc == UTF8PROC_BOUNDCLASS_LV ||                // ---
      tbc == UTF8PROC_BOUNDCLASS_LVT)) ? false :      // ---
    ((lbc == UTF8PROC_BOUNDCLASS_LV ||                // GB7
      lbc == UTF8PROC_BOUNDCLASS_V) &&                // ---
     (tbc == UTF8PROC_BOUNDCLASS_V ||                 // ---
      tbc == UTF8PROC_BOUNDCLASS_T)) ? false :        // ---
    ((lbc == UTF8PROC_BOUNDCLASS_LVT ||               // GB8
      lbc == UTF8PROC_BOUNDCLASS_T) &&                // ---
     tbc == UTF8PROC_BOUNDCLASS_T) ? false :          // ---
    (tbc == UTF8PROC_BOUNDCLASS_EXTEND ||             // GB9
     tbc == UTF8PROC_BOUNDCLASS_ZWJ ||                // ---
     tbc == UTF8PROC_BOUNDCLASS_SPACINGMARK ||        // GB9a
     lbc == UTF8PROC_BOUNDCLASS_PREPEND) ? false :    // GB9b
    (lbc == UTF8PROC_BOUNDCLASS_E_ZWG &&              // GB11 (requires additional handling below)
     tbc == UTF8PROC_BOUNDCLASS_EXTENDED_PICTOGRAPHIC) ? false : // ----
    (lbc == UTF8PROC_BOUNDCLASS_REGIONAL_INDICATOR &&          // GB12/13 (requires additional handling below)
     tbc == UTF8PROC_BOUNDCLASS_REGIONAL_INDICATOR) ? false :  // ----
    true; // GB999
}

static utf8proc_bool grapheme_break_extended(int lbc, int tbc, int licb, int ticb, utf8proc_int32_t *state)
{
  if (state) {
    int state_bc, state_icb; /* boundclass and indic_conjunct_break state */
    if (*state == 0) { /* state initialization */
      state_bc = lbc;
      state_icb = licb == UTF8PROC_INDIC_CONJUNCT_BREAK_CONSONANT ? licb : UTF8PROC_INDIC_CONJUNCT_BREAK_NONE;
    }
    else { /* lbc and licb are already encoded in *state */
      state_bc = *state & 0xff;  // 1st byte of state is bound class
      state_icb = *state >> 8;   // 2nd byte of state is indic conjunct break
    }

    utf8proc_bool break_permitted = grapheme_break_simple(state_bc, tbc) &&
       !(state_icb == UTF8PROC_INDIC_CONJUNCT_BREAK_LINKER
        && ticb == UTF8PROC_INDIC_CONJUNCT_BREAK_CONSONANT); // GB9c

    // Special support for GB9c.  Don't break between two consonants
    // separated 1+ linker characters and 0+ extend characters in any order.
    // After a consonant, we enter LINKER state after at least one linker.
    if (ticb == UTF8PROC_INDIC_CONJUNCT_BREAK_CONSONANT
        || state_icb == UTF8PROC_INDIC_CONJUNCT_BREAK_CONSONANT
        || state_icb == UTF8PROC_INDIC_CONJUNCT_BREAK_EXTEND)
      state_icb = ticb;
    else if (state_icb == UTF8PROC_INDIC_CONJUNCT_BREAK_LINKER)
      state_icb = ticb == UTF8PROC_INDIC_CONJUNCT_BREAK_EXTEND ?
                  UTF8PROC_INDIC_CONJUNCT_BREAK_LINKER : ticb;

    // Special support for GB 12/13 made possible by GB999. After two RI
    // class codepoints we want to force a break. Do this by resetting the
    // second RI's bound class to UTF8PROC_BOUNDCLASS_OTHER, to force a break
    // after that character according to GB999 (unless of course such a break is
    // forbidden by a different rule such as GB9).
    if (state_bc == tbc && tbc == UTF8PROC_BOUNDCLASS_REGIONAL_INDICATOR)
      state_bc = UTF8PROC_BOUNDCLASS_OTHER;
    // Special support for GB11 (emoji extend* zwj / emoji)
    else if (state_bc == UTF8PROC_BOUNDCLASS_EXTENDED_PICTOGRAPHIC) {
      if (tbc == UTF8PROC_BOUNDCLASS_EXTEND) // fold EXTEND codepoints into emoji
        state_bc = UTF8PROC_BOUNDCLASS_EXTENDED_PICTOGRAPHIC;
      else if (tbc == UTF8PROC_BOUNDCLASS_ZWJ)
        state_bc = UTF8PROC_BOUNDCLASS_E_ZWG; // state to record emoji+zwg combo
      else
        state_bc = tbc;
    }
    else
      state_bc = tbc;

    *state = state_bc + (state_icb << 8);
    return break_permitted;
  }
  else
    return grapheme_break_simple(lbc, tbc);
}
