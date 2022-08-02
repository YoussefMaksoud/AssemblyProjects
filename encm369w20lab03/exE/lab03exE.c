// lab03exE.c: ENCM 369 Winter 2020 Lab 3 Exercise E

// INSTRUCTIONS:
//   You are to write a MARS translation of this C program, compatible
//   with all of the calling conventions presented so far in ENCM 369.


int foo(int x, int bound);

int foo_sum(const int *x, int n, int b);

int aaa[] = {9, -11, 12, 7, -15};
int bbb[] = {-21, 1, 3};
int ccc[] = {-101, 0, 0, 102, 0, 0, -100};

int main(void)
{
    // Normally you could pick whatever s-registers you like for
    // alpha, beta, and gamma.  However in this exercise you should
    // use $s0 for alpha, $s1 for beta, and $s2 for gamma -- this will
    // help make sure you learn to manage s-registers correctly.
    
    int alpha, beta, gamma;
    gamma = 2000;
    alpha = foo_sum(aaa, 5, 10);
    beta = foo_sum(bbb, 3, 20);
    gamma += (foo_sum(ccc, 7, 100) + alpha - beta);

    // Here gamma should have a value of 2322, which is 0x912. 

    return 0;
}

int foo(int x, int bound)
{
  int rv;
  rv = x;
  if (x > bound || x < -bound)
    rv = bound;
  else if (x < 0)
    rv = -x;
  return rv;
}

int foo_sum(const int *x, int n, int b)
{
  // Normally you could pick whatever s-registers you like for 
  // x, n, b, k and sum.  However in this exercise you must use 
  // $s0 for x, $s1 for n, $s2 for b, $s3 for k, and $s4 for sum.
  // That will help make sure you manage s-registers correctly.

  int k;
  int sum;
  sum = 0;
  for (k = 0; k < n; k++)
    sum += foo(x[k], b);
  return sum;
}
