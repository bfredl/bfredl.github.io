#include <stdbool.h>

int knovel;
typedef struct {
  int *fulpekar;
  float boll;
  int ball;
} typen;

typen getta_data(void) {
  return (typen){.fulpekar = &knovel, .boll = 3.0, .ball = false};
}
