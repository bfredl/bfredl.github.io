
2014:
EXTERN schar_T  *ScreenLines INIT(= NULL);
EXTERN sattr_T  *ScreenAttrs INIT(= NULL);
EXTERN u8char_T *ScreenLinesUC INIT(= NULL);    /* decoded UTF-8 characters */
EXTERN u8char_T *ScreenLinesC[MAX_MCO];         /* composing characters */
EXTERN schar_T  *ScreenLines2 INIT(= NULL);

how popupmenu is being redrawn (redraw everything panic)

2015:
INTERMISSION: tarrudas "rich ui" blog post

2015-2016:
nvim goes `encoding=utf-8` only. Thus `ScreenLines2` goes away.
https://github.com/neovim/neovim/pull/2905

2017:
First sketch of "multigrid" (ref relevant PR)

2018:
https://github.com/neovim/neovim/pull/7992 Represent Screen state as UTF-8 
https://github.com/neovim/neovim/pull/8221 linegrid mode
very important: regard screen state as line segments in general

2019:
- introduce compositor for pum only
- floating windows!


separate topic: screen-tests
Tarrudas first PR:
https://github.com/neovim/neovim/pull/1835 screen:snapshot_util()
