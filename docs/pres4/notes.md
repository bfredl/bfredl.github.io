
ABSTRACT
=====
Unicode and emoji in Neovim: Neovim 0.11 contains a significant upgrade to its multibyte text implementation, including support of new emoji from recent Unicode standard versions. This will be presented along with historical background of internationalized text and vim's support for it. Are "multibyte", "wide characters" and "Unicode" all the same thing? And how did funny color pictures end up being the flagship feature of a standard meant to encode written languages from around the world?

=====

- background of unicode

- The stoneage time: code pages
  - maybe a bit about DBCS ? (optional if too much content)

- some terminology:
  - Unicode is a Standard
  - a file is sequence of bytes, 8-bit integers
  - in order to interprete it as a text, an **encoding** is needed
  - ASCII
  - IEC_8859-1, latin-1 vs cp-1252
  - multibyte (UTF-8,dbcs) vs widechar (UTF-16/32)

- Unicode 1.0 (1991): 65536 characters should be enough for everyone
https://www.unicode.org/versions/Unicode1.0.0/
Proposal [by whom]: 31-bit chars, up to 2 billion characters
compromise:
- Unicode 2.0 (1996): 17*)2^16)=1.1M characters should be enough for everyone

- fun slide: acme as first editor with UTF-8 support, ☺☻☹.c

- grapheme clusters
- emoji

- multibyte support in vim and neovim:
- first builds of vim only supported single-byte text (latin-1 and similar)
- 'encoding' vs 'fileencoding'

- vim 5.2 "multibyte" (DBCS only)
(convenient: many early 2-byte encodings defined the cell width to be the byte width)

- vim 6.0: first version with (utf-8 Sun Jul 30 23:10:55 2000)
