extern int name_to_color(const unsigned char *name);

int fubbig(void)
{
  return name_to_color((unsigned char *)"Magenta");
}
