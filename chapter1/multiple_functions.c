#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct point {
  double x;
  double y;
} point_t;

double square(double a) {
  return a * a;
}

double distance(point_t a, point_t b) {
  return sqrt(square(a.x - b.x) + square(a.y - b.y));
}

int fib(int n) {
  if (n < 2)
    return 1;
  return fib(n-1) + fib(n-2);
}

void splitprint(char buffer[], int lenght);

int main(int argc, char *argv[]) {
  point_t a, b;

  a.x = 10;
  a.y = 15;

  b.x = 30;
  b.y = 45;

  printf("distance: %2.f\n", distance(a, b));
  printf("fib(5): %d\n", fib(5));

  char name[] = "123456789";
  splitprint(name, 9);
}

void splitprint(char buf[], int len) {
  int i;
  for (i = 0; i < len; i++) {
    printf("%c ", buf[i]);
  }
  printf("\n");
}
