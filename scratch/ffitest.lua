ffi.cdef([[
typedef struct foo { int a, b; } foo_t;  // Declare a struct and typedef.
int dofoo(foo_t *f, int n);  /* Declare an external C function. */
]],"int y")

