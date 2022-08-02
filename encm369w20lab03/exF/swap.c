// swap.c
// ENCM 369 Winter 2020 Lab 3 Exercise F


// INSTRUCTIONS:
//   A partially-completed assembly language translation of this
//   file can be found in swap.asm.  Complete the translation
//   by adding the necessary instructions to main and swap in
//   swap.asm.

void swap(int *p, int *q);
// REQUIRES:
//   p and q point to variables
// PROMISES:
//   *p == original value of *q.
//   *q == original value of *p.


int quux[] =  { 0x11, 0x21, 0x31, 0x41, 0x51, 0x61 };

int main(void)
{
  // These three swaps will reverse the order of the elements
  // in the array quux.
  swap(&quux[2], &quux[3]);
  swap(&quux[1], &quux[4]);
  swap(&quux[0], &quux[5]);

  return 0;
}

void swap(int *p, int *q)
{
  // Hint: Think carefully about when use of the C * operator
  // means "load" and when it means "store".

  int old_star_p;

  old_star_p = *p;
  *p = *q;
  *q = old_star_p;
}
