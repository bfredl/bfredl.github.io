typedef struct {
  Object types;
} KeyDict_context;

extern KeySetLink context_table[];
#define api_free_keydict_context(x) api_free_keydict(x, context_table)
typedef struct {
  Object on_buf;
  Object on_end;
  Object on_win;
  Object on_line;
  Object on_start;
  Object _on_hl_def;
  Object _on_spell_nav;
} KeyDict_set_decoration_provider;

extern KeySetLink set_decoration_provider_table[];
#define api_free_keydict_set_decoration_provider(x) api_free_keydict(x, set_decoration_provider_table)
typedef struct {
  Object id;
  Object spell;
  Object hl_eol;
  Object strict;
  Object end_col;
  Object conceal;
  Object hl_mode;
  Object end_row;
  Object end_line;
  Object hl_group;
  Object priority;
  Object ephemeral;
  Object sign_text;
  Object virt_text;
  Object ui_watched;
  Object virt_lines;
  Object line_hl_group;
  Object right_gravity;
  Object sign_hl_group;
  Object virt_text_pos;
  Object virt_text_hide;
  Object number_hl_group;
  Object virt_lines_above;
  Object end_right_gravity;
  Object virt_text_win_col;
  Object virt_lines_leftcol;
  Object cursorline_hl_group;
} KeyDict_set_extmark;

extern KeySetLink set_extmark_table[];
#define api_free_keydict_set_extmark(x) api_free_keydict(x, set_extmark_table)
typedef struct {
  Object desc;
  Object expr;
  Object script;
  Object silent;
  Object unique;
  Object nowait;
  Object noremap;
  Object callback;
  Object replace_keycodes;
} KeyDict_keymap;

extern KeySetLink keymap_table[];
#define api_free_keydict_keymap(x) api_free_keydict(x, keymap_table)
typedef struct {
  Object builtin;
} KeyDict_get_commands;

extern KeySetLink get_commands_table[];
#define api_free_keydict_get_commands(x) api_free_keydict(x, get_commands_table)
typedef struct {
  Object bar;
  Object addr;
  Object bang;
  Object desc;
  Object count;
  Object force;
  Object nargs;
  Object range;
  Object preview;
  Object complete;
  Object register_;
  Object keepscript;
} KeyDict_user_command;

extern KeySetLink user_command_table[];
#define api_free_keydict_user_command(x) api_free_keydict(x, user_command_table)
typedef struct {
  Object col;
  Object row;
  Object win;
  Object style;
  Object title;
  Object width;
  Object height;
  Object zindex;
  Object anchor;
  Object border;
  Object bufpos;
  Object external;
  Object relative;
  Object focusable;
  Object noautocmd;
  Object title_pos;
} KeyDict_float_config;

extern KeySetLink float_config_table[];
#define api_free_keydict_float_config(x) api_free_keydict(x, float_config_table)
typedef struct {
  Object is_lua;
  Object do_source;
} KeyDict_runtime;

extern KeySetLink runtime_table[];
#define api_free_keydict_runtime(x) api_free_keydict(x, runtime_table)
typedef struct {
  Object winid;
  Object fillchar;
  Object maxwidth;
  Object highlights;
  Object use_winbar;
  Object use_tabline;
} KeyDict_eval_statusline;

extern KeySetLink eval_statusline_table[];
#define api_free_keydict_eval_statusline(x) api_free_keydict(x, eval_statusline_table)
typedef struct {
  Object buf;
  Object win;
  Object scope;
  Object filetype;
} KeyDict_option;

extern KeySetLink option_table[];
#define api_free_keydict_option(x) api_free_keydict(x, option_table)
typedef struct {
  Object bg;
  Object fg;
  Object sp;
  Object bold;
  Object link;
  Object blend;
  Object cterm;
  Object italic;
  Object special;
  Object ctermbg;
  Object ctermfg;
  Object default_;
  Object altfont;
  Object reverse;
  Object fallback;
  Object standout;
  Object nocombine;
  Object undercurl;
  Object underline;
  Object background;
  Object bg_indexed;
  Object foreground;
  Object fg_indexed;
  Object global_link;
  Object underdashed;
  Object underdotted;
  Object underdouble;
  Object strikethrough;
} KeyDict_highlight;

extern KeySetLink highlight_table[];
#define api_free_keydict_highlight(x) api_free_keydict(x, highlight_table)
typedef struct {
  Object bold;
  Object italic;
  Object altfont;
  Object reverse;
  Object standout;
  Object nocombine;
  Object undercurl;
  Object underline;
  Object underdashed;
  Object underdotted;
  Object underdouble;
  Object strikethrough;
} KeyDict_highlight_cterm;

extern KeySetLink highlight_cterm_table[];
#define api_free_keydict_highlight_cterm(x) api_free_keydict(x, highlight_cterm_table)
typedef struct {
  Object id;
  Object link;
  Object name;
} KeyDict_get_highlight;

extern KeySetLink get_highlight_table[];
#define api_free_keydict_get_highlight(x) api_free_keydict(x, get_highlight_table)
typedef struct {
  Object event;
  Object group;
  Object buffer;
  Object pattern;
} KeyDict_clear_autocmds;

extern KeySetLink clear_autocmds_table[];
#define api_free_keydict_clear_autocmds(x) api_free_keydict(x, clear_autocmds_table)
typedef struct {
  Object desc;
  Object once;
  Object group;
  Object buffer;
  Object nested;
  Object command;
  Object pattern;
  Object callback;
} KeyDict_create_autocmd;

extern KeySetLink create_autocmd_table[];
#define api_free_keydict_create_autocmd(x) api_free_keydict(x, create_autocmd_table)
typedef struct {
  Object data;
  Object group;
  Object buffer;
  Object pattern;
  Object modeline;
} KeyDict_exec_autocmds;

extern KeySetLink exec_autocmds_table[];
#define api_free_keydict_exec_autocmds(x) api_free_keydict(x, exec_autocmds_table)
typedef struct {
  Object event;
  Object group;
  Object buffer;
  Object pattern;
} KeyDict_get_autocmds;

extern KeySetLink get_autocmds_table[];
#define api_free_keydict_get_autocmds(x) api_free_keydict(x, get_autocmds_table)
typedef struct {
  Object clear;
} KeyDict_create_augroup;

extern KeySetLink create_augroup_table[];
#define api_free_keydict_create_augroup(x) api_free_keydict(x, create_augroup_table)
typedef struct {
  Object cmd;
  Object reg;
  Object bang;
  Object addr;
  Object mods;
  Object args;
  Object count;
  Object magic;
  Object nargs;
  Object range;
  Object nextcmd;
} KeyDict_cmd;

extern KeySetLink cmd_table[];
#define api_free_keydict_cmd(x) api_free_keydict(x, cmd_table)
typedef struct {
  Object bar;
  Object file;
} KeyDict_cmd_magic;

extern KeySetLink cmd_magic_table[];
#define api_free_keydict_cmd_magic(x) api_free_keydict(x, cmd_magic_table)
typedef struct {
  Object tab;
  Object hide;
  Object split;
  Object browse;
  Object filter;
  Object silent;
  Object confirm;
  Object keepalt;
  Object sandbox;
  Object verbose;
  Object unsilent;
  Object vertical;
  Object keepjumps;
  Object keepmarks;
  Object lockmarks;
  Object noautocmd;
  Object horizontal;
  Object noswapfile;
  Object emsg_silent;
  Object keeppatterns;
} KeyDict_cmd_mods;

extern KeySetLink cmd_mods_table[];
#define api_free_keydict_cmd_mods(x) api_free_keydict(x, cmd_mods_table)
typedef struct {
  Object force;
  Object pattern;
} KeyDict_cmd_mods_filter;

extern KeySetLink cmd_mods_filter_table[];
#define api_free_keydict_cmd_mods_filter(x) api_free_keydict(x, cmd_mods_filter_table)
typedef struct {
  Object output;
} KeyDict_cmd_opts;

extern KeySetLink cmd_opts_table[];
#define api_free_keydict_cmd_opts(x) api_free_keydict(x, cmd_opts_table)
typedef struct {
  Object verbose;
} KeyDict_echo_opts;

extern KeySetLink echo_opts_table[];
#define api_free_keydict_echo_opts(x) api_free_keydict(x, echo_opts_table)
typedef struct {
  Object output;
} KeyDict_exec_opts;

extern KeySetLink exec_opts_table[];
#define api_free_keydict_exec_opts(x) api_free_keydict(x, exec_opts_table)
