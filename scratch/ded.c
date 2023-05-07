#include <stdio.h>

int main(void)
{
  int a[256] = { 0 };     // indexes where byte first appears, -1 if
  int b = 224;
  int c = a[b & 0xff];
  printf("DD %d", c);
}
