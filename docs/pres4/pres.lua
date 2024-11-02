local m = dofile'/home/bfredl/config2/nvim/lua/bfredl/moonwatch.lua'
_G.m = m
local a = bfredl.a

local sf = m.float
_G.sf = sf

local s = m.make_show("Unicode in neovim and beyond", _G.s)
_G.s = s

m.prepare()
m.cls()


clight = "#FFFFFF"
cnormal = "#e0e0e0"
cmiddim = "#aaaaaa"
cfwd = "#CC3333"
cback = "#1199DD"
cbackdark = "#042367"
caccent = "#E8BB22"
cmid = "#6822AA"
cmiddark = "#32016b"

a.set_hl(0, "BrightFg", {fg=clight, bold=true})
a.set_hl(0, "FwdFg", {fg=cfwd, bold=true})
a.set_hl(0, "BackFg", {fg=cback, bold=true})
a.set_hl(0, "BackMidFg", {fg="#0020CC"})
a.set_hl(0, "BackMidFgDim", {fg="#111111", bg="#aaaaaa"})
a.set_hl(0, "BackDarkFg", {fg=cbackdark})
a.set_hl(0, "BackDarkBg", {bg=cbackdark})
a.set_hl(0, "DimFg", {fg="#777777"})
a.set_hl(0, "AccentFg", {fg=caccent, bold=true})
a.set_hl(0, "PlainUnderline", {underline=true})
a.set_hl(0, "StartFg", {fg="#22FF33"})
a.set_hl(0, "ContBg", {bg="#441111"})
a.set_hl(0, "ContFg", {fg="#cc1111"})
a.set_hl(0, "AltFont", {altfont=true})
a.set_hl(0, "FAkeCursor", {fg="#AADDFF", reverse=true})
a.set_hl(0, "FloatBorder", {fg="#BBCCFF", bg=cmiddark, blend=0})
a.set_hl(0, "Termish", {fg="#33DD44", bg="#101a10"})
--a.set_hl(0, "Tagged", {reverse=true, sp="#000000", underdouble=true})
a.set_hl(0, "Tagged", {sp="#bbbbbb", underdouble=true})
a.set_hl(0, "UnTagged", {reverse=true})
a.set_hl(0, "Author", {fg="#FFCC00"})
a.set_hl(0, "Fuling", {sp="#FFCC00"})
a.set_hl(0, "VeryError", {bg="#AA0000", fg="#EEFFFF", bold=true})
a.set_hl(0, "Koden", {undercurl=true, bg=cbackdark})
a.set_hl(0, "RedNumber", {fg="#AA3333"})

ns = a.create_namespace'pres'

function hl(nam, l, c, c2)
  a.buf_add_highlight(0, ns, nam, l, c, c2)
end

function issue(r, num, name, date, idim)
  date = date and (" ("..date..")") or ""
  sf {r=r, c=8, text=num..": "..name..date, fn=function()
    hl("BrightFg", 0, 0, #num+1)
    hl("DimFg", 0, #num+2+#name, -1)
    if idim then
      hl("DimFg", 0, #num+1, #num+2+#name)
    end
  end}
end

function no_slide() end

function embedditor(filnamn)
  local fil = vim.fn.bufadd(filnamn)

  local ww = sf {r=5, c=8, h=18, w=80, bg=cbackdark, buf=fil, focusable=true, fn=function()
    vim.api.nvim_win_set_cursor(0, {1, 0})
  end}
  if vim.fn.has'gui_running' > 0 then vim.api.nvim_set_current_win(ww) end
  sf {r=3, c=5, h=22, w=86, bg=cback}
end

vim.cmd [[ hi Normal guibg=#080808 guifg=#e0e0e0]]

vim.lsp.stop_client(vim.lsp.get_clients())
vim.cmd [[set shortmess+=F]]
vim.cmd [[set winblend=0]]

s:permanent_bar(function(name)
  if name == 'titlepage' then return end

  sf {r=35, c=2, w=91, text=[[ Unicode and Neovim                  Neovimconf 2024                            Bfredl     ]], bg=cbackdark, fn=function()
    hl('Author', 0, 75, -1)
end}
end)

s:slide('titlepage', function()
  m.header 'Unicode and emoji in neovim'

  fn = 'showcase/titlemoji.cat'
  sf {r=6, c=28, h=17, w=45, bg="Termish", fn=function()
    local term = vim.api.nvim_open_term(0, {})
    local ros = io.open(fn):read'*a'
    vim.api.nvim_chan_send(term, ros)
  end}

  sf {r=26, center='c', text="A presentation for Neovimconf 2024"}
  sf {r=27, center='c', text="by Bfredl"}


  sf {r=35, c=3, w=90, bg="#d8d8d8"}
  -- IMAGEN
end)

s:slide('nvim11', function()
  m.header 'New in Neovim 0.11: emoji support'

  -- sf {r=3, text="NB: not in all terminal emulators"}

  local x, y = 15, 35
  sf {r=5, c=x, text="before"}
  sf {r=5, c=y, text="after"}

  sf {r=7, c=x, text="😂"}
  sf {r=7, c=y, text="😂"}
  sf {r=8, c=x, text="❤"}
  sf {r=8, c=y, text="❤️"}
  sf {r=9, c=x, text="🧑🌾"}
  sf {r=9, c=y, text="🧑‍🌾"}
  sf {r=10, c=x, text="🏳️<200d>⚧️"} --TODO: special hl!
  sf {r=10, c=y, text="🏳️‍⚧️"}
  sf {r=11, c=x, text="🇦 🇽 🇧 🇷  x"}
  sf {r=11, c=y, text="🇦🇽 🇧🇷"}

  sf {r=14, text="These were added as emoji to unicode in 2015-2020"}
  sf {r=15, text="Why did did take so long to get them into nvim? and why do they fail so differently?"}
  sf {r=16, text="Why is the headline feature in recent unicode revisions funny color pictures?"}
end)

s:slide("whoami", function()
  m.header 'Whoami'
  sf {r=4, w=58, text=[[
- One of the long-time contributors at this point
- core maintainer, focus on low-level stuff
- Paid contributor, very thanks to our sponsors
  ]]}

  -- IMAGEN

  sf {r=12, text=[[
- github.com/bfredl                matrix.to/#/@bfredl:matrix.org
  ]], bg="#", fg=caccent}
end)

function chapter(nam) 
  sf {r=10, center='c', c=40, bg='FloatBorder', text=nam}
  sf {r=7, c=8, h=5, w=66, bg='FloatBorder', border='single'}
end

s:slide("part1", function()
  chapter("Part 1: Origin and evolution of Unicode")
end)

function ascii(row)
  -- TODO: hex numbers?
  sf {r=row, c=9, h=8, w=68, text=[[
00  NUL SOH STX ETX EOT ENQ ACK BEL  BS TAB  LF  VT  FF  CR  SO  SI
10  DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN  EM SUB ESC  FS  GS  RS  US
20  SPC  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /
30   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
40   @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
50   P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _
60   `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o
70   p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~  DEL
]], fn=function() 
  hl("DimFg", 0, 4, 40)
  hl("DimFg", 0, 47, -1)
  hl("DimFg", 1, 4, -1)
  hl("DimFg", 7, 64, -1)
  for i=0,7 do
    hl("Number", i, 0, 2)
  end
end}

end

s:slide('ascii', function()
  m.header 'ASCII (1967, 1977)'

  sf {r=4, text="ASCII was standardized in the 1960:s as a 7-bit encoding"}
  sf {r=5, text="ASCII-1967 very close to what we know as ASCII today"}
  sf {r=6, text="with some ambiguities locked down in 1977"}

  sf {r=8, text="Originally designed for teletypewriters (digitalized telegraphs)"}
  sf {r=9, text="which evolved into (printing!) computer terminals"}

  -- ASCII table here
  ascii(11)

  sf {r=20, text="Meanwhile, the personal computing world standardized on 8-bit bytes"}


  sf {r=24, text="There was also the rival standard EBCDIC used by IBM mainframes"}
  sf {r=25, text="We are not going to talk about EBCDIC"}
end)


s:slide_multi('8bitworld', 6, function(i)
  m.header '8-bit codepages (what is "plain text" anyway)'

  sf {r=3, text="A file stored on disk or in memory is a sequence of 8-bit numbers (0-255)"}
  sf {r=4, text="to show these as text on a printer or screen, an Encoding is needed"}

  ascii(9)
  local thetext, thename = "", ""

if i == 2 then
  thename = "iso latin-1 (ISO/IEC 8859-1)"
  thetext=[[
80                   ( C1: more control codes
90                     no one uses anymore :p )
A0 NBSP  ¡   ¢   £   ¤   ¥   ¦   §   ¨   ©   ª   «   ¬  SHY  ®   ¯
B0   °   ±   ²   ³   ´   µ   ¶   ·   ¸   ¹   º   »   ¼   ½   ¾   ¿
C0   À   Á   Â   Ã   Ä   Å   Æ   Ç   È   É   Ê   Ë   Ì   Í   Î   Ï
D0   Ð   Ñ   Ò   Ó   Ô   Õ   Ö   ×   Ø   Ù   Ú   Û   Ü   Ý   Þ   ß
E0   à   á   â   ã   ä   å   æ   ç   è   é   ê   ë   ì   í   î   ï
F0   ð   ñ   ò   ó   ô   õ   ö   ÷   ø   ù   ú   û   ü   ý   þ   ÿ
]]

elseif i == 3 then
  thename = [[MS WINDOWS cp-1252 ("latin-1")]]
  thetext=[[
80   €       ‚   ƒ   „   …   †   ‡   ˆ   ‰   Š   ‹   Œ       Ž
90   ‘   ’   “   ”   •   –   —   ˜   ™   š   ›   œ           ž   Ÿ
A0 NBSP  ¡   ¢   £   ¤   ¥   ¦   §   ¨   ©   ª   «   ¬  SHY  ®   ¯
B0   °   ±   ²   ³   ´   µ   ¶   ·   ¸   ¹   º   »   ¼   ½   ¾   ¿
C0   À   Á   Â   Ã   Ä   Å   Æ   Ç   È   É   Ê   Ë   Ì   Í   Î   Ï
D0   Ð   Ñ   Ò   Ó   Ô   Õ   Ö   ×   Ø   Ù   Ú   Û   Ü   Ý   Þ   ß
E0   à   á   â   ã   ä   å   æ   ç   è   é   ê   ë   ì   í   î   ï
F0   ð   ñ   ò   ó   ô   õ   ö   ÷   ø   ù   ú   û   ü   ý   þ   ÿ
]]

elseif i == 1 then
  -- TODO: show the 00 10 overlay (not usable in text)
  thename = "MS-DOS (IBM PC OEM code page)"
  thetext = [[
80   Ç   ü   é   â   ä   à   å   ç   ê   ë   è   ï   î   ì   Ä   Å
90   É   æ   Æ   ô   ö   ò   û   ù   ÿ   Ö   Ü   ¢   £   ¥   ₧   ƒ
A0   á   í   ó   ú   ñ   Ñ   ª   º   ¿   ⌐   ¬   ½   ¼   ¡   «   »
B0   ░   ▒   ▓   │   ┤   ╡   ╢   ╖   ╕   ╣   ║   ╗   ╝   ╜   ╛   ┐
C0   └   ┴   ┬   ├   ─   ┼   ╞   ╟   ╚   ╔   ╩   ╦   ╠   ═   ╬   ╧
D0   ╨   ╤   ╥   ╙   ╘   ╒   ╓   ╫   ╪   ┘   ┌   █   ▄   ▌   ▐   ▀
E0   α   ß   Γ   π   Σ   σ   µ   τ   Φ   Θ   Ω   δ   ∞   φ   ε   ∩
F0   ≡   ±   ≥   ≤   ⌠   ⌡   ÷   ≈   °   ∙   ·   √   ⁿ   ²   ■ NBSP
  ]]

elseif i == 4 or i == 5 then
  -- note CA is really ⁄ but that's hard to render surrounded by spaces
  thename = (i == 4) and "MACRO MAN" or "MAC ROMAN"
  thetext = [[
80   Ä   Å   Ç   É   Ñ   Ö   Ü   á   à   â   ä   ã   å   ç   é   è
90   ê   ë   í   ì   î   ï   ñ   ó   ò   ô   ö   õ   ú   ù   û   ü
A0   †   °   ¢   £   §   •   ¶   ß   ®   ©   ™   ´   ¨   ≠   Æ   Ø
B0   ∞   ±   ≤   ≥   ¥   µ   ∂   ∑   ∏   π   ∫   ª   º   Ω   æ   ø
C0   ¿   ¡   ¬   √   ƒ   ≈   ∆   «   »   … NBSP  À   Ã   Õ   Œ   œ
D0   –   —   “   ”   ‘   ’   ÷   ◊   ÿ   Ÿ   ⟋   €   ‹   ›   ﬁ   ﬂ
E0   ‡   ·   ‚   „   ‰   Â   Ê   Á   Ë   È   Í   Î   Ï   Ì   Ó   Ô
F0   🍎  Ò   Ú   Û   Ù   ı   ˆ   ˜   ¯   ˘   ˙   ˚   ¸   ˝   ˛   ˇ
  ]]
elseif i == 6 then
  thename = "ISO/IEC 8859-5: Cyrilic"
  thetext=[[
80                   ( C1: more control codes
90                     no one uses anymore :p )
A0 NBSP  Ё   Ђ   Ѓ   Є   Ѕ   І   Ї   Ј   Љ   Њ   Ћ   Ќ  SHY  Ў   Џ
B0   А   Б   В   Г   Д   Е   Ж   З   И   Й   К   Л   М   Н   О   П 
C0   Р   С   Т   У   Ф   Х   Ц   Ч   Ш   Щ   Ъ   Ы   Ь   Э   Ю   Я
D0   а   б   в   г   д   е   ж   з   и   й   к   л   м   н   о   п
E0   р   с   т   у   ф   х   ц   ч   ш   щ   ъ   ы   ь   э   ю   я
F0   №   ё   ђ   ѓ   є   ѕ   і   ї   ј   љ   њ   ћ   ќ   §   ў   џ
]]
end

  sf {r=7, c=43, center="c", text=thename}
  sf {r=17, c=9, h=8, w=68, text=thetext, fn=function()
    for l=0,8 do
      hl("RedNumber", l, 0, 2)
    end
  end}

  if i >= 6 then
    sf {r=28, text="High risk for misinterpreting high bytes (mojibake)"}
    sf {r=29, text="ASCII: lingua franca for interpreting 0-127 byte values"}
    sf {r=31, text=[[intepreting the rest required choosing a "code page" (locale settings, ugh)]]}
  end
  -- ASCI values are preserved between MS-DOS, lose-DOS, lunix, mac etc.
  -- the others: not so much
end)

s:slide_multi('dbcsworld', 2, function(i)
  m.header 'Double byte character sets (East Esian)'

  sf {r=3, text="Early multi-byte encodings for Japanese, Chinese, etc"}

  sf {r=5, c=40, text="Shift-JIS"}

  sf {r=7, c=9, h=16, w=68, text=[[
00  NUL SOH STX ETX EOT ENQ ACK BEL  BS TAB  LF  VT  FF  CR  SO  SI
10  DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN  EM SUB ESC  FS  GS  RS  US
20  SPC  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   / 
30   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ? 
40   @C  A   B   C   D   E   F   G   H   I   J   K   L   M   N   O 
50   PC  Q   R   S   T   U   V   W   X   Y   Z   [   ¥   ]   ^   _ 
60   `C  a   b   c   d   e   f   g   h   i   j   k   l   m   n   o 
70   pC  q   r   s   t   u   v   w   x   y   z   {   |   }   ~  DEL
80   -   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S 
90   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S 
A0       ｡   ｢   ｣   ､   ･   ｦ   ｧ   ｨ   ｩ   ｪ   ｫ   ｬ   ｭ   ｮ   ｯ 
B0   ｰ   ｱ   ｲ   ｳ   ｴ   ｵ   ｶ   ｷ   ｸ   ｹ   ｺ   ｻ   ｼ   ｽ   ｾ   ｿ 
C0   ﾀ   ﾁ   ﾂ   ﾃ   ﾄ   ﾅ   ﾆ   ﾇ   ﾈ   ﾉ   ﾊ   ﾋ   ﾌ   ﾍ   ﾎ   ﾏ 
D0   ﾐ   ﾑ   ﾒ   ﾓ   ﾔ   ﾕ   ﾖ   ﾗ   ﾘ   ﾙ   ﾚ   ﾛ   ﾜ   ﾝ   ﾞ   ﾟ 
E0   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S   S 
F0   S   S   S   S   S   S   S   S   S   S   S   S   S   -   -   -
]], fn=function() 
  hl("DimFg", 0, 4, 40)
  hl("DimFg", 0, 47, -1)
  hl("DimFg", 1, 4, -1)
  hl("DimFg", 7, 64, -1)
  hl("ErrorMsg", 5, 52, 56)
  hl("StartFg", 8, 7, -1)
  hl("StartFg", 9, 4, -1)
  hl("StartFg", 14, 4, -1)
  hl("StartFg", 15, 4, 55)
  for l=0,15 do
    hl("Number", l, 0, 2)
  end
  for l=10,13 do
    for g=0,15 do
      -- these are not exact. just good enough for the FULING
      hl("Fuling", l, 3+6*g, 4+6*g)
    end
  end
  if i==2 then
    for l=4,15 do
      local e = -1
      if l == 7 then e = 63 end
      if l == 15 then e = 55 end
      hl("ContBg", l, 4, e)
    end
  end
end}

  sf {r=25, text="A Start byte + continuation byte w some restrictions", fn=function()
    hl("StartFg", 0, 2, 7)
    if i >= 2 then hl("ContBg", 0, 15, 32) end
  end}
  sf {r=26, text="94*94 = 8836 double-byte codes"}

  sf {r=28, text="+ byte width == terminal column width!"}
  sf {r=30, c=8, text=[[ strlen("ab") == 2      strlen("文字") == 4 ]]}
  sf {r=32, text="- not self-synchronizing, partial overlap with ASCII"}
end)

s:slide_multi('xkcdstandards', 1, function(i)
  m.header "Ridiculous! we need to develop one universal standard that covers everyone's use cases"

  sf {r=8, text="An universal encoding would need:"}
  sf {r=10, text="  - substantially larger than 8-bit (224 visible chars)"}
  sf {r=12, text="  - shared across major vendors (IBM PC, MS, Apple, Unix)", fg=caccent}
  sf {r=13, text="     - backwards compat with ASCII"}
  sf {r=14, text="     - can map to language-specific extensions"}

end)


s:slide_multi('ucscode', 2, function(i)
    m.header "Unicode vs ISO/IEC 10646"
    local bg1 = "#000065"
    local bg2 = "#500000"
    local bg3 = "#005500"

    sf {r=5, text="unicode: a set of rules for processing international text", bg=bg1}
    sf {r=6, text="- 16-bit character set: max 65 536 codepoints", bg=bg1}
    sf {r=7, text=[[- some codepoints combine to form more glyphs]], bg=bg1}
    sf {r=8, text=[[- rules for bidirectional text, case conversion, sorting, normalization, etc]], bg=bg1}
    sf {r=4, c=2, w=82, h=6, bg=bg1}

    sf {r=15, text="UCS (ISO/IEC 10646): a character set to superseed all earlier character sets", bg=bg2}
    sf {r=16, text="- UCS-4: 600 million codepoints (4-byte code space with some restrictions) ", bg=bg2}
    sf {r=17, text="- Most common chars in UCS-2 (basic multilingual plane) ", bg=bg2}
    sf {r=18, text="- UTF-1, a predecessor to UTF-8 (variable width encoding)", bg=bg2}
    sf {r=14, c=2, w=82, h=6, bg=bg2}

  if i >= 2 then
    -- HANDSHAKE EMOJI
    sf {r=12, c=40, text="🤝", bg="AltFont"}
    sf {r=25, text=[[Agreement: there should be one shared character database ]], bg=bg3}
    sf {r=26, text=[[- ISO 10646 UCS-2 standardizes the same codepoints as unicode 1.0 (1991)]], bg=bg3}
    sf {r=24, c=2, w=82, h=4, bg=bg3}
  end
end)

s:slide('16bitworld', function()
  m.header 'A modest proposal: 16-bit characters'

  sf {r=3, text="Unicode 88: Need for a new, world-wide ASCII"}

  orignal = [[
Are 16 bits, providing at most 65,536 distinct codes, sufficient to encode
all characters of all the world’s scripts? Since the definition of a
“character” is itself part of the design of a text encoding scheme, the
question is meaningless unless it is restated as: Is it possible to
engineer a reasonable definition of “character” such that all the world’s
scripts contain fewer than 65,536 of them?
  ]]

  -- TODO best to keep full text, but use HiGHLiGHtS
  sf {r=5, c=8, w=76, h=11, bg=cbackdark, text=[[
Are 16 bits, providing at most 65,536 distinct codes, sufficient to encode
all characters of all the world’s scripts? Since the definition of a
“character” is itself part of the design of a text encoding scheme, the
question is meaningless unless it is restated as: Is it possible to
engineer a reasonable definition of “character” such that all the world’s
scripts contain fewer than 65,536 of them?

The answer to this is Yes. (Of course, the converse need not be true, i.e.
it is certainly possible, albeit uninteresting, to come up with
unreasonable definitions of “character" such that there are more than 65,536
of them.)]]}


  sf {r=18, text=[[The "reasonable" definition:]]}
  sf {r=20, text=[[ - modern use: "the union of all papers and magazines printed in the world in 1988"]]}
  sf {r=23, text=[[Han unification:]]}

  sf {r=25, c=15, w=70, text=[[ "consolidating together the ideographic characters
used in writing Chinese, Japanese, and Korean."]]}

  sf {r=28, text=[[ - A somewhat controversial topic]]}
  sf {r=29, text=[[ - regardless, it is fair to say that the sizing constraint imposed a ]]}
  sf {r=30, text=[[   _bias_ towards unifying more characters rather than less]]}
end)

function bytesof(num, n)
  local bits = {}
  for i=1,n do
    if i > 1 and i%4 == 1 then
      table.insert(bits, ' ')
    end
    local test = bit.band(num, bit.lshift(1,n-i))
    local bit = (test > 0) and "1" or "0"
    table.insert(bits, bit)
  end
  return table.concat(bits)
end

s:slide('unicode1.0', function()
  m.header '1991: Unicode 1.0, the WIDECHAR world'
  -- the fucking ascii vs wide ascii side by side table
  -- from unicode standard 1.0

  local bright = true
  local ascii = 'this is text'
  -- local uni = {'G', 'å', ' ', 'β', ' ', 'こ', 'ん', 'に', 'ち', 'は'}
  local uni = {'G', 'å', ' ', 'β', ' ', '今', '日', 'は', ' ', '⇖', '≧ ', '☺'}

  sf {r = 3, c=21, text="ASCII"}
  sf {r = 3, c=49, text="UNICODE"}
  for i = 1,12 do
    local bg = bright and cmid or cbackdark

    local r = 4+i
    local char = string.sub(ascii, i, i)
    local byt = string.byte(char)
    local bytestr = bytesof(byt,8)

    sf {r=r, c=10+8, bg=bg, text=bytestr}
    sf {r=r, c=10+19, bg=bg, text=char}

    local unichar = uni[i]
    local num = vim.fn.char2nr(unichar)
    local numstr = bytesof(num,16)

    sf {r=r, c=10+30, bg=bg, text=numstr}
    sf {r=r, c=10+51, w=2, bg=bg, text=unichar}

    bright = not bright
  end
  
  -- TODO: not sure what to do with this, highlight the last sentence? (UTF-8 delivered on this, not UCS-2:p)
  local text = [[
The Unicode character encoding standard is a fixed-width, uniform text and character encoding
scheme. It includes characters from the world’s scripts, as well as technical symbols in common
use. The Unicode standard is modeled on the ASCII character set. Since ASCII's 7-bit character size
is inadequate to handle multilingual text, the Unicode Consortium adopted a 16-bit architecture
which extends the benefits of ASCII to multilingual text. Unicode characters are consistently 16
bits wide, regardless of language, so no escape sequence or control code is required to specify any
character in any language. Unicode character encoding treats symbols, alphabetic characters, and
ideographic characters identically, so that they can be used simultaneously and with equal facility.
Computer programs that use Unicode character encoding to represent characters but do not dis-
play or print text can (for the most part) remain unaltered when new scripts or characters are
introduced.
]]

  sf {r=19, text="Right then: Unicode just IS UCS-2, i e Unicode is an encoding"}
  sf {r=20, text="yes but: byte order. UCS-2BE vs UCS-2LE (big vs little endian)"}

  -- explain how this is the seed of the mayhem which will ensure
  --sf {r=22, text="yes but: spacing marks"}

  sf {r=25, text="WIDECHAR word:"}
  sf {r=27, text="- java, javascript, windows NT"}
  sf {r=28, text="- rewrite your c/c++ codes to use wchar_T * instead of char *", fn=function()
    hl('BackDarkBg', 0, 34, 43)
    hl('BackDarkBg', 0, 55, 61)
  end}

end)

s:slide('robpike', function()
  -- TODO: better assentuate the 3 important properties (for the time)
  -- 1. still gigachad 31bit UCS, not prematurely optimied for UNICODE-91 aka UCS-2
  --    (would have made BMP encoding more efficient _then_, but at a high cost later..)
  -- 2. ASCII is exactly preserved like in the latin-1 style encodings
  -- 3. fully self-synchronizing (finite lookback)

  m.header '1992: An encoding backwards compat with ASCII?'
  -- praise our lord and saviour: plan-9
  
  sf {r=3, text="ISO/IEC 10646 draft (4 byte chars): multibyte encoding to save space, UTF-1"}

  sf {r=4, text="New proposal by IBM and X/Open in collaboration with Rob Pike and Ken Thompson:"}

  sf {r=6, c=40, text="UTF-8"}
  ascii(8)
  -- TODO: colors!
  sf {r=16, c=9, h=8, w=68, text=[[
80   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C
90   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C
A0   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C
B0   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C   C
C0  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2
D0  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2  S2
E0  S3  S3  S3  S3  S3  S3  S3  S3  S3  S3  S3  S3  S3  S3  S3  S3
F0  S4  S4  S4  S4  S4  S4  S4  S4  S5  S5  S5  S5  S6  S6   X   X
]], fn=function()
  for l=0,7 do
    hl("Number", l, 0, 2)
  end
    for l=0,3 do
      hl("ContFg", l, 4, -1)
    end
    for l=4,7 do
      local e = -1
      if l == 7 then e = 60 end
      hl("StartFg", l, 4, e)
    end
end}

  sf {r=26, text=[[- 00-7F bytes encode ASCII and ONLY ASCII]]}
  sf {r=27, text=[[  UCS text inside "mostly ASCII" fileformats like c,html,lua etc ]]}
  sf {r=29, text="- Raw encoding supports up to 2 billion chars (UCS-4)"}
  sf {r=30, text="- Fully self-synchronizing: start bytes are unique"}

  sf {r=17, c=9, h=8, w=68, text=thetext}
  
  sf {r=32, text="MULTIBYTE word: plan9, HTML/XML, modern POSIX, vim!!"}
  --sf {r=31, text=[[Software which stores/transmits extended ASCII can be unmodified!]]}
  -- "multibyte" like earlier DBSC encod in g
end)

s:slide('utf-16', function()
  m.header "what if 65 536 characters are NOT enough?"

  sf {r=4, text=[[unicode 2.0 (1996): oooooopsie!]]}

  sf {r=7, text="High surrogates U+D800 to U+DBFF (2^10 distinct values)"}
  sf {r=8, text="low surrogates: U+DC00 to U+DFFF (2^10 distinct values)"}

  sf {r=10, text="These exists within the UCS-2 space but are not charcters per se"}
  sf {r=11, text="instead a sequence high+low encodes 2^20 ~= 1 million codepoints"}

  sf {r=14, text="Thus as a compromise, UCS-4 nominally exists but is limited to the range 0-10FFFF"}

  sf {r=16, c=20, w=52, text=[[

 Encoding │ Size of codepoint │ Compatibility
 ─────────┼───────────────────┼────────────────────
  UTF-8   │ 1-4 bytes         │ Extended ASCII
  UTF-16  │ 2 (BMP) or 4      │ Unicode 1.0 (UCS-2)
  UTF-32  │ 4 bytes           │
 ]], fg="#77DDFF"}


  sf {r=25, text="wHeN iN doUbt, foLLoW wHaT ThE wEB Is dOInG"}
  sf {r=27, text="looking inside:"}
  sf {r=28, text="HTTPS/HTML/XML: UTF-8 as the universal TRANSMISSION format"}
  sf {r=29, text="javascript: but UTF-16 as the PROCESSING format"}
end)

no_slide('whatisunicode', function()
  m.header "What's in the unicode standard? anyway?"

  sf {r=5, text="the Unicode Character database"}
  sf {r=6, text="- 154 998 codepoints assigned out of 1 114 111"}
  sf {r=7, text="- Categoratizions of codepoints into letters, punctuation, numbers, etc"}
  sf {r=8, text="- Rules how to encode these as UTF-32, UTF-16, UTF-8"}
  sf {r=9, text="- Same encodings standardized as ISO 10646: Universal coded character set"}

  sf {r=12, text="But the unicode standard contains so much more:"}
  sf {r=13, text="- core specification: 23 chapters"}
  sf {r=14, text="- Unicode Standard annexes: 20 more documents "}
  sf {r=15, text="- X machine readable data files "}
  sf {r=19, text="rules for:"}
  sf {r=20, text="- bidirectional text (Arabic, Hebrew, etc)"}
  sf {r=21, text="- case conversion and case-insensitive comparison"}
  sf {r=22, text="- Normalization (composition/decomposition)"}
  sf {r=23, text="- segmenting into graphemes, words, sentences"}
  sf {r=24, text="- East Asian Width (single, double or ambiguous width)"}
end)

no_slide('UnicodeData.txt', function()
  m.header 'UnicodeData.txt'
  embedditor('showcase/UnicodeData.txt')
end)

no_slide('normalization', function()
  m.header 'Normalization'

  sf {r=4, text=[[
[ins] In [8]: dict(ｸ=2)['ｸ']
---------------------------------------------------------------------------
KeyError                                  Traceback (most recent call last)
Cell In[8], line 1
----> 1 dict(ｸ=2)['ｸ']

KeyError: 'ｸ'

[ins] In [21]: dict(ﬁﬁﬁ=0)
Out[21]: {'fififi': 0}
  ]]}
end)

s:slide('whatis', function()
  m.header 'Now for something completely different'

  sf {r=4, text="What is a character?"}
  sf {r=5, text="given a valid unicode string how _many_ characters are in it?"}
  sf {r=9, text="strlen(str), #str, str.length, str.__len__() ?"}
  sf {r=11, c=15, text="UTF-8 bytes, UTF-16 codeunits or codepoints"}
  sf {r=15, text="Already in unicode 1.0: 'non-spacing marks'"}

  local alttexter = function() hl('AltFont', 0, 0, -1) end
  local r = 18
  local c = 6
  sf {r=r+2, c=c+5, bg=cbackdark, text='Å', center='c', fn=alttexter}
  sf {r=r+4, c=c+5, bg=cbackdark, text='U+00C5', center='c'}
  sf {r=r+0, c=c+0, w=10, h=5, bg=cbackdark}

  sf {r=r+2, c=22, text=':'}

  c=30
  sf {r=r+2, c=c+5, bg=cbackdark, text='A', center='c', fn=alttexter}
  sf {r=r+4, c=c+5, bg=cbackdark, text='U+0041', center='c'}
  sf {r=r+0, c=c+0, w=10, h=5, bg=cbackdark}

  c=41
  sf {r=r+2, c=c+5, bg=cbackdark, text='°', center='c', fn=alttexter}
  sf {r=r+4, c=c+5, bg=cbackdark, text='U+030A', center='c'}
  sf {r=r+0, c=c+0, w=10, h=5, bg=cbackdark}

  sf {r=r+6, c=9, text="NFC"}
  sf {r=r+7, c=7, text="Composed"}

  sf {r=r+6, c=39, text="NFD"}
  sf {r=r+7, c=35, text="Decomposed"}

  --sf {r=25, text="(1) i.e. well-formed UTF-8/16/32 which maps to assigned code points"}

end)

s:slide_multi('Graphemes', 7, function(i)
  m.header 'Grapheme clusters'

  sf {r=3, text='UAX #29 : text segmentation'}
  sf {r=5, w=80, text=[[
determining default segmentation boundaries between certain text elements:
grapheme clusters (“user-perceived characters”), words, and sentences. ]]}

  if i>= 2 then sf {r=9, text="Unicode 4.0 (2003): non-spacing marks and hangul syllabes"} end -- 29-8(?) 
  if i>= 3 then sf {r=10, text="Unicode 5.1 (2008): Extended Grahpeme clusters"} end -- 29-13
  if i>= 4 then sf {r=11, text="Unicode 6.0 (2012): RI-sequences (country codes)"} end
  if i>= 5 then sf {r=12, text="Unicode 9.0 (2016): Emoji (first try)"} end
  if i>= 6 then sf {r=13, text="Unicode 16.0 (2024): today"} end

  texte = {
    "( CRLF | !Control  Grapheme_Extend* | Control )",
    "( CRLF | ( Hangul-syllable | !Control ) Grapheme_Extend* | . )",
    "( CRLF | Prepend* ( Hangul-syllable | !Control ) (Grapheme_Extend | spacing_mark) * | . )",
[[
( CRLF | Prepend* ( RI-sequence | Hangul-syllable | !Control )
         (Grapheme_Extend | spacing_mark) * | . )]],
[[
( CRLF | Prepend* ( RI-sequence | Hangul-syllable | emoji-sequence | !Control )
         (Grapheme_Extend | spacing_mark) * | . )]],
[[
( CRLF | Prepend* ( RI-sequence | Hangul | xpicto-sequence | indic-conjuncts | !Control )
         (Grapheme_Extend | ZWJ | spacing_mark) * | . )]],
  }
  texte[7] = texte[6]

  sf {r=15, text=texte[i]}

  if i>=1 then sf {r=19, text=[[ Grapheme_Extend := Nonspacing_Mark | Enclosing_Mark ]]} end
  if i>=2 then sf {r=20, text=[[ Hangul-Syllable := L* V+ T*| L* LV V* T* | L* LVT T*| L+ | T+ ]]} end
  if i>=4 then sf {r=21, text=[[ Emoji-sequence := E_Base (Extend | E_modifier)* (ZWJ E_Base_after_Modifier)*  ]]} end
  if i>=6 then sf {r=22, text=[[ xpicto-sequence := Extended_Pictographic (Extend* ZWJ Extended_Pictographic})*  ]]} end
  if i>=6 then sf {r=23, text=[[ indic-conjucts := Consonant ([Extend Linker]* Linker Extend Linker]* Consonant)+]]} end
  --
  if i>=7 then sf {r=26, text=[[
This document defines a default specification for grapheme clusters. It may
be customized for particular languages, operations, or other situations.
For example, arrow key movement could be tailored by language, or could use
knowledge specific to particular fonts to move in a more granular manner,
in circumstances where it would be useful to edit individual components. ]], fn=function()
  hl('AccentFg', 1, 2, 38)
  hl('AccentFg', 3, 0, 38)
end}
end

end)

s:slide("part2", function()
  chapter("Part 2: Unicode in Vim and Neovim")
end)

s:slide_multi('vimhistory', 2, function(i)
  m.header 'vim-history'

  sf {r=4, text="Github repo with reconstructed vim history"}
  sf {r=5, text="https://github.com/vim/vim-history/"}

  sf {r=7, text="vim 4.0 and earlier: charset.c"}
  sf {r=8, text="support for character properties for 8-bit codepages"}

  sf {r=10, text="vim 5.2, 1998 first version with multibyte support"}
  sf {r=15, text="vim 6.0, 2000 UTF-8 support"}

  sf {r=18, text="🤔", bg="AltFont"}

  if i >= 2 then
    sf {r=12, c=20, text="DBCS encodings: strlen(x) == strwidth(x) "}
  end

  -- screenshot just to boast about compiled vim6.0

  -- so "multibyte" is not UTF-8?? explain
end)

s:slide_multi('vim6', 3, function(i)
  m.header 'vim6 compiled'

  fn = {'showcase/vim6_intro.cat', 'showcase/vim6_version.cat', 'showcase/vim6_demo.cat' }
  sf {r=3, c=6, h=23, w=81, bg="Termish", fn=function()
    local term = vim.api.nvim_open_term(0, {})
    local ros = io.open(fn[i]):read'*a'
    vim.api.nvim_chan_send(term, ros)
  end}
end)

no_slide('vimscreen', 3, function(i)
  m.header 'vim in encoding=utf-8 mode'

  sf {r=4, text="Buffer lines are NUL-terminated strings encoded as UTF-8"}

  sf {r=6, text="but in the screen buffers, it looks like this"}

  texte = {[[
EXTERN schar_T  *ScreenLines INIT(= NULL);   // ASCII only! otherwise 0
EXTERN u8char_T *ScreenLinesUC INIT(= NULL); // decoded UTF-8 characters
EXTERN u8char_T *ScreenLinesC[MAX_MCO];      // composing characters
]],
[[
uint8_t ScreenLines[rows*cols];          // ASCII only! otherwise 0
int32_t ScreenLinesUC[rows*cols];        // decoded UTF-8 characters
int32_t ScreenLinesC[p_mco][rows*cols];  // composing characters
int p_mco;  // 'maxcombine' option, up to MAX_MCO = 6 ]]}

  sf {r=8, w=80, text=texte[math.min(i, 2)], bg=cbackdark}

sf {r=13, text="so when rendering a window:"}
sf {r=14, text="buffer UTF-8 text is converted to UTF-32 + 6 * UTF-32"}
sf {r=15, text=".. and then converted back to UTF-8 for the terminal (or gtk)"}

if i>= 3 then
  sf {r=17, text="This has gone through multiple revisions in Neovim, currently"}

  nvimtext = [[
typedef char[4] schar_T;
schar_T  chars[rows*cols];   // ASCII only! otherwise 0
char glyph_cache[size];      // cache of NUL-terminated glyphs
]]
  sf {r=20, w=80, text=nvimtext, bg=cbackdark}

  sf {r=25, text=[[
┌────┬────┬────┬────┐
│ C3 │ 85 │ 00 │ 00 │
└────┴────┴────┴────┘
]], fn=function()
hl('StartFg', 1, 4, 6)
hl('ContFg', 1, 11, 13)
end}

  sf {r=29, text=[[
┌────┬────┬────┬────┐
│ FF │ 00 │ 01 │ 22 │
└────┴────┴────┴────┘
]], fn=function()
hl('VeryError', 1, 4, 6)
end}

sf {r=26, c=30, text=[[ Up to 4 UTF-8 bytes ]]}
sf {r=30, c=30, text=[[ 24-bit index into glyph_cache[x] ]]}
end

-- TODO illustration of schar_T

end)

no_slide('vimunidata' ,function()
  m.header 'vim unicode data'

  sf {r=4, text=[[
" Edit the Unicode text file.  Requires the netrw plugin.
edit http://unicode.org/Public/UNIDATA/UnicodeData.txt

" Parse each line, create a list of lists.
call ParseDataToProps()

" Build the toLower table.
call BuildCaseTable("Lower", 13)

" Build the toUpper table.
call BuildCaseTable("Upper", 12)

" Build the ranges of composing chars.
call BuildCombiningTable()
]]}
end)

s:slide('vimptr', function()
  m.header "User editable chars in vim and nvim 0.10" --- {{{
  code = [[
/// Return the number of bytes occupied by a UTF-8 character in a string
/// This includes following composing characters.
int utfc_ptr2len(unsigned char *p)
{
  if (p[0] < 0x80 && p[1] < 0x80) {  // be quick for ASCII
    return 1;
  }

  int prevpos = 0;
  int pos = utf_ptr2len(p); // single codepoint length

  // Check for composing characters.


  while (true) {
    bool composing = p[pos] >= 0x80 // is multibyte
                     && (utf_iscomposing(&p[pos])
                         || arabic_combine(&p[prevpos], &p[pos]));

    if (!composing);
      return pos;
    }

    // Skip over composing char.
    prevpos = pos; pos += utf_ptr2len(p + pos);
  }
}
]]
-- }}}
  sf {r=4, c=4, w=87, text=code, bg=cbackdark, fn=function()
    vim.cmd [[ set ft=c ]]
  end}
end)

s:slide('nvim11ptr' ,function()
  m.header "User editable chars in nvim 0.11-dev" -- {{{
  code = [[
/// Return the number of bytes occupied by a UTF-8 character in a string
/// This includes following composing characters.
int utfc_ptr2len(unsigned char *p)
{
  if (p[0] < 0x80 && p[1] < 0x80) {  // be quick for ASCII
    return 1;
  }

  int prevpos = 0;
  int pos = utf_ptr2len(p); // single codepoint length

  // Check for composing characters.

  utf8proc_int32_t state = GRAPHEME_STATE_INIT;
  while (true) {
    bool composing = p[pos] >= 0x80 // is multibyte
                     && (utf8proc_grapheme_break_stateful(ptr2char(&p[prevpos]),
                                                          ptr2char(&p[pos]), state)
                         || arabic_combine(&p[prevpos], &p[pos]));
    if (!composing);
      return pos;
    }

    // Skip over composing char.
    prevpos = pos; pos += utf_ptr2len(p + pos);
  }
}]]
  -- }}}
  sf {r=4, c=4, w=87, text=code, bg=cbackdark, fn=function()
    vim.cmd [[ set ft=c ]]
  end}
end)

s:slide('utf8proc', function()
  m.header "Utf8proc: a modern library for unicode"
  local fil = vim.fn.bufadd("showcase/utf8proc.c")
  local ww = sf {r=3, w=85, h=30, buf=fil, bg=cbackdark, focusable=true, fn=function()
    vim.api.nvim_win_set_cursor(0, {1, 0})
    -- vim.cmd [[ set ft=c ]]
  end}
  if vim.fn.has'gui_running' > 0 then vim.api.nvim_set_current_win(ww) end


  -- this is very complex, but not our problem!
end)

s:slide("part3", function()
  chapter("Part 3: Emoji")
end)

s:slide('emoji_intro', function()
  m.header 'emojis: what, wow, why'

  sf {r=3, text="unicode has always included simple uncolored pictographs:"}
  sf {r=5, c=10, text="☺ ♜ ☿ ♥"}

  sf {r=8, text="in the early 2000:s:"}
  sf {r=9, text="color emoji Used in japanese messaging services"}
  sf {r=10, text="But incompatible sets by different carriers and phone manufacturers !"}
  sf {r=12, text="Adaption of Unicode in Japan was slow (han unification, etc)"}

  sf {r=15, text="Explicit goal of unicode: compatibility with existing encodings"}
  sf {r=16, text="Thus, a set of 720 emoji was added to unicode 5.2"}
  sf {r=17, text="including giving color presentation to existing pictographs!"}

  sf {r=20, text="Naturally, this 'comptibility' feature become very popular around the world.."}

end)


s:slide_multi('emoji_variants', 4, function(i)
  m.header 'how emojis are encoded'
  sf {r=4, text="single codepoint: 😂"}
  if i >= 2 then sf {r=5, text="variant selector: ❤️"} end
  if i >= 3 then sf {r=6, text="ZWJ joiner: 🧑‍🌾 "} end
  if i >= 4 then sf {r=7, text="ZWJ joiner + variant selector: 🏳️‍⚧️"} end

  local texte = ''
  local cell = {}
  if i == 1 then
    texte = [[1F602;FACE WITH TEARS OF JOY]]
    cell = {'😂'}
  elseif i == 2 then
    texte = [[2764;HEAVY BLACK HEART
FE0F;VARIATION SELECTOR-16]]
    cell = {'❤', 'VS-16', '❤️'}
  elseif i == 3 then
    texte = [[
1F9D1;ADULT
0200D;ZERO WIDTH JOINER
1F33E;EAR OF RICE ]]
    cell = {'🧑', 'ZWJ', '🌾', '🧑‍🌾' }
  elseif i == 4 then
    texte = [[
1F3F3;WAVING WHITE FLAG
0FE0F;VARIATION SELECTOR-16
0200D;ZERO WIDTH JOINER
026A7;TRANSGENDER SYMBOL
0FE0F;VARIATION SELECTOR-16]]
    cell = {'🏳', 'VS-16', 'ZWJ', ' ⚧', 'VS-16', '🏳️‍⚧️'}
  end
  sf {r=22, w=35, h=5, text=texte}

  local bright = true
  for i=1,#cell do
    local c = cell[i]

    local bg = bright and "#115577" or cbackdark

    local col = 9+10*(i-1)
    if i == #cell and #cell > 1 then
      sf {r=12, c=col+4, text='=', bg='AltFont'}
      col = col + 10
    end
    local alt = vim.api.nvim_strwidth(c) <= 2
    -- col adj is bull, fix altfont centering!
    sf {r=12, c=col+(alt and 3 or 5), bg=bg, text=c, center='c', fn=function()
      if alt then
        hl('AltFont', 0, 0, -1)
      end
    end}
    sf {r=10, c=col, w=10, h=5, bg=bg}

    bright = not bright
  end
  if i == 4 then
    sf {r=15, c=9, w=20, bg='PlainUnderline'}
    sf {r=15, c=39, w=20, bg='PlainUnderline'}
    sf {r=18, c=16, text='🏳️', bg='AltFont'}
    sf {r=18, c=46, text='⚧️', bg='AltFont'}
  end

  local data = [[
  
1F602                             ; fully-qualified     # 😂 E0.6 face with tears of joy
2764 FE0F                         ; fully-qualified     # ❤️ E0.6 red heart
1F9D1 200D 1F33E                  ; fully-qualified     # 🧑‍🌾 E12.1 farmer
1F3F3 FE0F 200D 26A7 FE0F         ; fully-qualified     # 🏳️‍⚧️ E13.0 transgender flag
  ]]
end)

function emojiat(row, col, emoji, lowtext, bg, noalt)
  bg = bg or cbackdark
  sf {r=row+2, c=col+3, bg=bg, text=emoji, center='c', fn=function()
    if not noalt then
      hl('AltFont', 0, 0, -1)
    end
  end}
  if lowtext then
    sf {r=row+4, c=col, bg=bg, text=lowtext}
  end
  sf {r=row, c=col, w=10, h=5, bg=bg}
end

s:slide_multi('zwjmania', 2, function(i)
  m.header "modifiers and ZWJ: a grammar for emoji"


  --   adult       man      woman
  --    🧑          👨        👩
  --    plus ZWJ + 🎨
  --     🧑‍🎨        👨‍🎨         👩‍🎨
  d = 12
  emojiat(3, 10, '🧑', '    ADULT')
  emojiat(3, 10+d, '👨', '     MAN')
  emojiat(3, 10+2*d, '👩', '    WOMAN')

  if i >= 1 then
    emojiat(10, 10, '🧑‍🎨', '  ARTIST', i>=2 and "#009038" or nil)
    emojiat(10, 10+d, '👨‍🎨', 'MAN ARTIST')
    emojiat(10, 10+2*d, '👩‍🎨', 'W. ARTIST')

    sf {r=5, c=52, text='+', bg='AltFont'}
    emojiat(3, 60, '    ZWJ', nil, nil, true)
    emojiat(3, 60+d, '🎨')
  end

  if i >= 2 then
    sf {r=20, c=14, text='+', bg='AltFont'}
    ba = 22
    --: 🏻 🏼 🏽 🏾 🏿
    --: 🏼 🏽 🏾 🏿
    emojiat(18, ba, ' 🏼 ', 
    'LIGHT', 'Koden')
    emojiat(18, ba+d, ' 🏽 ',  
    'MID-LIGHT', 'Koden')
    emojiat(18, ba+2*d, ' 🏽 ', 
    'MEDIUM', 'Koden')
    emojiat(18, ba+3*d, ' 🏾 ', 
    'MID-DARK', 'Koden')
    emojiat(18, ba+4*d, ' 🏿 ', 
    'DARK', 'Koden')

    emojiat(24, ba, '🧑🏻‍🎨')
    emojiat(24, ba+d, '🧑🏼‍🎨')
    emojiat(24, ba+2*d, '🧑🏽‍🎨')
    emojiat(24, ba+3*d, '🧑🏾‍🎨')
    emojiat(24, ba+4*d, '🧑🏿‍🎨')

   sf {r=32, text=[[unicode.org/emoji/about-emoji: "Race is Not a Skin Tone. Gender is Not a Haircut."]]}
  end
  -- emoji modifiers:
  -- the three genders: person, man, woman
  -- skin colors

  -- and then "holding hands", "family" combinatorial explosions
end)

s:slide_multi('countryflags', 4, function(i)
  m.header "But there's more: country flags!"

  sf {r=3, text="regional indicator code points: 🇦- 🇿"}
  sf {r=4, text="Juxtaposing two of these and using ISO country codes gives flags"}

  sf {r=6, c=12, text=" 🇧 🇷 =  🇧🇷 "}
  sf {r=7, c=12, text=" 🇸 🇪 =  🇸🇪 "}

  d = 12
  r = 12
  -- 🇩🇪🇪🇨🇨🇦🇦🇷
  strings = {'🇩', '-', '🇪', '🇨', '🇦', '🇷', '!'}
  str = {
    '🇩-🇪🇨 🇦🇷 !',
    '🇩🇪 🇨🇦 🇷!'
  }

  -- fina strängen
  local tep = math.floor((i+1)/2)
  sf {r=10, text="my_string = '"..str[tep].."'", fn=function()
    if i == 1 then
      hl("FAkeCursor", 0, 0, 1)
    elseif i == 2 then
      hl("FAkeCursor", 0, 13+4, 13+5)
    elseif i == 4 then
      hl("FAkeCursor", 0, 13+22, 13+23)
    end
  end}
  if i >= 3 then
    table.remove(strings, 2)
  end
  for j = 1,#strings do
    emojiat(r, 5+11*(j-(2-tep)), strings[j])
  end

  -- 

  --sf {r=20, c=8, text=table.concat(strings)}



end)

s:slide_multi('tagsequences', 3, function(i)
  m.header 'yoo dawg I heard you like ascii'

  sf {r=3, text="Only countries and self-ruling territories have 2-letter ISO codes"}
  sf {r=5, text="Many sub-national entries such as provinces, federatal states have flags"}

  sf {r=6, text="ISO-foo provides standardized subnational codes"}

  sf {r=8, text="Unicode 10 added a few of these, such as Scotland"}
  sf {r=10, c=10, text="🏴󠁧󠁢󠁳󠁣󠁴󠁿  Scotland (GB-SCT)"}

  local strings = {"🏴", "G", "B", "S", "C", "T", "␄"}
  local chars = {"1F3F4", "E0067", "E0062", "E0073", "E0063", "E0074", "E007F"}
  if i>=2 then
    for j = 1,#strings do
      bull = j == 1 and cbackdark or nil
      row = 14
      col = 5+11*(j-1)
      sf {r=row+2, c=col+4, bg=bull or "Untagged", text=strings[j], center='c', fn=function()
          hl('AltFont', 0, 0, -1)
      end}
      sf {r=row+1, c=col+5, w=5, h=2, bg=bull or "UnTagged", center='c'}
      sf {r=row+4, c=col, bg=cbackdark, text='  U+'..chars[j]}
      sf {r=row, c=col, w=10, h=5, bg=cbackdark}
    end
  end

  if i >=3 then
    sf {r=21, center='c', text='Unicode Block: Tag sequences'}
    sf {r=23, c=7, h=12, w=75, text=[[
U+E0020  SPC  !   "   #   $   %   &   '   (   )   *   +   ,   -   .   / 

U+E0030   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ? 

U+E0040   @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O 

U+E0050   P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _ 

U+E0060   `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o 

U+E0070   p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~  END
]], fn=function()
      hl("DimFg", 7, 64, -1)
      for i=0,7 do
        hl("Number", 2*i, 0, 7)
        for k=0,15 do
          hl("Tagged", i*2, 9+4*k,12+4*k)
        end
      end
      --hl("Tagged", 0, 9,12)
      --hl("Tagged", 10, 69,72)
    end}
  end

  -- 1F3F4 E0067 E0062 E0073 E0063 E0074 E007F              ; fully-qualified     # 🏴󠁧󠁢󠁳󠁣󠁴󠁿 E5.0 flag: Scotland
end)

no_slide('emoji-test.txt', function()
  m.header 'emoji-test.txt'
  embedditor('showcase/emoji-test.txt')
end)

s:slide_multi('takeaway', 2, function(i)
  m.header 'Take away messages'

  sf {r=4, text='Plain text is now a big mess, but we need to do the work'}
  if i < 2 then return end

  sf {r=6, text='- "Unicode" is a lot more than the UCS-4 character set'}
  sf {r=7, text='- One does not simply index a string "by character"'}
  sf {r=8, text='- "fixed width" vs "variable-width" encoding no longer makes sense'}

  sf {r=10, text='Thanks for listening '}

end)


s:show (s.slides[s.cur] and s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

