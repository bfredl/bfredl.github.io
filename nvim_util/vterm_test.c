#include <vterm.h>
#include <vterm_keycodes.h>

int main(void)
{
  VTerm *vt;
  VTermScreen *vts;

  vt = vterm_new(10, 20);
  vterm_set_utf8(vt, 1);
  vts = vterm_obtain_screen(vt);
  vterm_screen_enable_altscreen(vts, true);
  vterm_screen_enable_reflow(vts, true);
  vterm_screen_set_damage_merge(vts, VTERM_DAMAGE_SCROLL);
  vterm_screen_reset(vts, 1);

  const char data1[] = "\x1b[?1049h\x1b[22;0;0t\x1b[22;0t\x1b[?1h\x1b=\x1b[H\x1b[2J\x1b]11;?\a\x1b[?2004h\x1b[?u\x1b[c\x1b[?25h";
  if (sizeof(data1) != 66+1) abort();
  vterm_input_write(vt, data1, 66);
  vterm_screen_flush_damage(vts);

  const char data2[] = "\x1b[?25l\x1b[>4;2m\x1b(B\x1b[m\x1b[H\x1b[2J\x1b[K\n\x1b[94m~\x1b[K\r\n~\x1b[K\r\n~\x1b[K\r\n~\x1b[K\r\n~\x1b[K\r\n~\x1b[K\r\n~\x1b[K\r\n\x1b(B\x1b[0;1;7m<No Name] 0,0-1  All\x1b]112\a\x1b[2 q\x1b]112\a\x1b[2 q\x1b[?1002h\x1b[?1006h\x1b[H\x1b[?25h";
  if (sizeof(data2) != 155+1) abort();
  vterm_input_write(vt, data2, 155);
  vterm_screen_flush_damage(vts);

  const char data3[] = "\x1b[?25l\x1b[?1004h\x1b[?25h";
  if (sizeof(data3) != 20+1) abort();
  vterm_input_write(vt, data3, 20);
  vterm_screen_flush_damage(vts);

vterm_set_size(vt, 10, 1);
vterm_screen_flush_damage(vts);

  const char data4[] = "\x1b[?25l\x1b(B\x1b[m\x1b[H\x1b[12X\n\x1b[12X\n\x1b[12X\n\x1b[12X\n\x1b[12X\n\x1b[12X\n\x1b[12X\n\x1b[12X\n\x1b[12X\n\x1b[12X\x1b[8A\x1b[94m~\x1b[11X\r\n~\x1b[11X\r\n~\x1b[11X\r\n~\x1b[11X\r\n~\x1b[11X\r\n~\x1b[11X\r\n~\x1b[11X\r\n\x1b(B\x1b[0;1;7m<a\x1b[9;3Hme] 0,0-1 \x1b(B\x1b[m\r\n\x1b[12X\x1b[H\x1b[?25h";
  if (sizeof(data4) != 190+1) abort();
  vterm_input_write(vt, data4, 190);
  vterm_screen_flush_damage(vts);

  const char data5[] = "\x1b[?25l\x1b]112\a\x1b[2 q\x1b]112\a\x1b[2 q\x1b[?25h";
  if (sizeof(data5) != 34+1) abort();
  vterm_input_write(vt, data5, 34);
  vterm_screen_flush_damage(vts);

  vterm_set_size(vt, 1, 1);  // crash!
  vterm_screen_flush_damage(vts);
}
