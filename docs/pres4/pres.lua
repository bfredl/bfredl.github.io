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

a.set_hl(0, "BrightFg", {fg=clight, bold=true})
a.set_hl(0, "FwdFg", {fg=cfwd, bold=true})
a.set_hl(0, "BackFg", {fg=cback, bold=true})
a.set_hl(0, "BackMidFg", {fg="#0020CC"})
a.set_hl(0, "BackMidFgDim", {fg="#111111", bg="#aaaaaa"})
a.set_hl(0, "BackDarkFg", {fg=cbackdark})
a.set_hl(0, "DimFg", {fg="#777777"})
a.set_hl(0, "AccentFg", {fg=caccent, bold=true})

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

vim.cmd [[ hi Normal guibg=#080808 guifg=#e0e0e0]]

vim.lsp.stop_client(vim.lsp.get_active_clients())
vim.cmd [[set shortmess+=F]]
vim.cmd [[set winblend=0]]

s:permanent_bar(function(name)
  if name == 'titlepage' then return end

  sf {r=35, c=2, w=91, text=[[ Unicode and Neovim,   more colors here,                        bfredl ]], bg=cbackdark}
end)

s:slide('titlepage', function()
  m.header 'Unicodes' -- TODO: fancy title

  sf {r=35, c=3, w=90, bg="#d8d8d8"}
  -- IMAGEN
end)

s:slide("intro", function()
  m.header 'Overview'
  sf {r=3, w=70, c=3, text=[[
- baaaa
  ]]}
end)

s:slide("whoami", function()
  m.header 'Whoami'
  sf {r=4, w=58, text=[[
- One of the old---s at this point
- core maintainer, focus on stuff
- Paid contributor, very thanks to our sponsors
  ]]}

  -- IMAGEN

  sf {r=12, text=[[
- github.com/bfredl                matrix.to/#/@bfredl:matrix.org
  ]], bg="#", fg=caccent}
end)

s:slide('nvim11', function()
  m.header 'New in Neovim 0.11: emoji support'

  sf {r=3, text="NB: not in all terminal emulators"}

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
  sf {r=11, c=x, text="🇦 🇽 🇧 🇷"}
  sf {r=11, c=y, text="🇦🇽 🇧🇷"}

  sf {r=14, text="most of there in unicode XX or earier"}
  sf {r=15, text="Why did id take so long? and why do they fail so differently?"}
  sf {r=16, text="Why is the headline feature in recent unicode revisions funny color pictures?"}
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

  -- ASCII table here
  ascii(9)

  sf {r=18, text="the personal computing world standardized on 8-bit bytes, with a 7-bit text encoding"}


  sf {r=20, text="There was also the rival standard EBCDIC used by IBM mainframes"}
  sf {r=21, text="We are not going to talk about EBCDIC"}
end)


s:slide_multi('8bitworld', 4, function(i)
  m.header '8-bit codepages (what is "plain text" anyway)'

  sf {r=3, text="A file stored on disk or in memory is a sequence of 8-bit numbers (0-255)"}
  sf {r=4, text="to interpret these as text, an Encoding is needed"}

  ascii(9)
  local thetext, thename = "", ""
if i == 1 then
  thename = "iso latin-1 (ISO/IEC 8859-1)"
  thetext=[[
80                   ( more control code no
90                     one uses anymore :p)
A0 NBSP  ¡   ¢   £   ¤   ¥   ¦   §   ¨   ©   ª   «   ¬  SHY  ®   ¯
B0   °   ±   ²   ³   ´   µ   ¶   ·   ¸   ¹   º   »   ¼   ½   ¾   ¿
C0   À   Á   Â   Ã   Ä   Å   Æ   Ç   È   É   Ê   Ë   Ì   Í   Î   Ï
D0   Ð   Ñ   Ò   Ó   Ô   Õ   Ö   ×   Ø   Ù   Ú   Û   Ü   Ý   Þ   ß
E0   à   á   â   ã   ä   å   æ   ç   è   é   ê   ë   ì   í   î   ï
F0   ð   ñ   ò   ó   ô   õ   ö   ÷   ø   ù   ú   û   ü   ý   þ   ÿ
]]
elseif i == 2 then
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

elseif i == 3 then
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
elseif i == 4 then
  -- note CA is really ⁄ but that's hard to render surrounded by spaces
  thename = "MAC ROMAN"
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
end

  sf {r=7, c=43, center="c", text=thename}
  sf {r=17, c=9, h=8, w=68, text=thetext}

  sf {r=28, text="... thus the 'extended latin' characters were often misinterpreted, but ASCII remained"}
  sf {r=29, text="ASCII become the lingua franca for interpreting 0-127 byte values"}
  sf {r=30, text=[[intepreting the rest required choosing a "code page" (locale settings, ugh)]]}
  -- ASCI values are preserved between MS-DOS, lose-DOS, lunix, mac etc.
  -- the others: not so much
end)

s:slide('dbscworld', function()
  m.header 'double byte character sets (east asian)'
end)

s:slide('xkcdstandards', function()
  m.header "Ridiculous! we need to develop one universal standard that covers everyone's use cases"

  sf {r=3, text="A new encoding scheme would need to:"}
  sf {r=4, text="  - be substantially larger than 8-bit (224 visible chars)"}
  sf {r=5, text="  - shared across all major vendors (IBM, MS, Apple, Unix)", fg=caccent}


  sf {r=7, text="Unicode vs ISO/IEC"}

  sf {r=10, text="UCS (ISO/IEC 10646)"}
end)

s:slide('16bitworld', function()
  m.header 'A modest proposal: 16-bit characters'

  sf {r=3, text="Unicode 88: Need for a new, word-wide ASCII"}

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
unreasonable definitions of “character such that there are more than 65,536
of them.)]]}


  -- the fucking ascii vs wide ascii side by side table
  -- from unicode standard 1.0
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

  sf {r=18, text="WIDECHAR word:"}
  sf {r=19, text="java, javascript, windows NT"}

end)

s:slide('robpike', function()
  m.header 'An encoding backwards compat with ASCII?'
  -- praise our lord and saviour: plan-9
  --
  
  sf {r=8, text="MULTIBYTE word: HTML/XML, modern linux, vim!!!!"}
  -- "multibyte" like earlier DBSC encod in g
end)

s:slide('whatisunicode', function()
  m.header "What's in the unicode standard? anyway?"
end)


s:slide('vimhistory', function()
  m.header 'vim-history'

  sf {r=4, text="github repo with reconstructed vim history"}
  sf {r=6, text="URL"}

  sf {r=10, text="vim 5.2, date: first version with multibyte support"}
  sf {r=11, text="vim 6.0, UTF-8 support"}

  -- screenshot just to boast about compiled vim6.0

  -- so "multibyte" is not UTF-8?? explain
end)

s:slide('emoji_intro', function()
  m.header 'emojis: what, whow, why'
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
    cell = {'❤', 'VS-16'}
  elseif i == 3 then
    texte = [[
1F9D1;ADULT
0200D;ZERO WIDTH JOINER
1F33E;EAR OF RICE ]]
    cell = {'❤', 'VS-16'}
  elseif i == 4 then
    texte = [[
1F3F3;WAVING WHITE FLAG
0FE0F;VARIATION SELECTOR-16
0200D;ZERO WIDTH JOINER
026A7;TRANSGENDER SYMBOL
0FE0F;VARIATION SELECTOR-16]]
    cell = {'❤', 'VS-16'}
  end
  sf {r=10, w=35, h=5, text=texte}

  local data = [[
  
1F602                             ; fully-qualified     # 😂 E0.6 face with tears of joy
2764 FE0F                         ; fully-qualified     # ❤️ E0.6 red heart
1F9D1 200D 1F33E                  ; fully-qualified     # 🧑‍🌾 E12.1 farmer
1F3F3 FE0F 200D 26A7 FE0F         ; fully-qualified     # 🏳️‍⚧️ E13.0 transgender flag
  ]]
end)

s:slide('zwjmania', function()
  m.header "modifiers and ZWJ: a grammar for emoji"
  -- emoji modifiers:
  -- the three genders: person, man, woman
  -- skin colors

  -- and then "holding hands", "family" combinatorial explosions
end)

s:slide('countryflags', function()
  m.header "But there's more: country flags!"
end)

s:slide('tagsequences', function()
  m.header 'yoo dawg I heard you like ascii'

  -- 1F3F4 E0067 E0062 E0073 E0063 E0074 E007F              ; fully-qualified     # 🏴󠁧󠁢󠁳󠁣󠁴󠁿 E5.0 flag: Scotland
end)

s:slide('references', function()
  m.header 'futher information'

  sf {r=4, text="Emoji support in terminals"}
  sf {r=5, text="https://mitchellh.com/writing/grapheme-clusters-in-terminals"}

  sf {r=7, text="History of emoji in unicode:"}
  sf {r=8, text="youtuuu"}

end)


s:slide('enda', function()
  m.header 'Thanks for listening'
end)

s:show (s.slides[s.cur] and s.cur or "titlepage")

vim.cmd [[map <pageDown> <cmd>lua s:mov(1)<cr>]]
vim.cmd [[map <pageUp> <cmd>lua s:mov(-1)<cr>]]

