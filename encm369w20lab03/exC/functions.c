// functions.c: ENCM 369 Winter 2020 Lab 3 Exercise C 

// INSTRUCTIONS:
//   You are to write a MARS translation of this C program.  Because
//   this is the first assembly language program you are writing where you
//   must deal with register conflicts and manage the stack, there are
//   a lot of hints given in C comments about how to do the translation.
//   In future lab exercises and on midterms, you will be expected
//   to do this kind of translation without being given very many hints!


// Hint: Function prototypes, such as the next two lines of C,
// are used by a C compiler to do type checking and sometimes type
// conversions in function calls.  They do NOT cause ANY assembly
// language code to be generated.

int shark(int arg0, int arg1, int arg2, int arg3);

int whale(int cat, int dog);

int tuna = 0x30000;

int main(void)
{
  // Hint: This is a nonleaf procedure, so it needs a stack frame.

  // Instruction: Normally you could pick whatever two s-registers you
  // like for horse and cow, but in this exercise you must use $s0
  // for horse and $s1 for cow.

  int horse;
  int cow;
  horse = 0x6000;
  cow = 0x2000;
  cow += shark(5, 4, 3, 2);
  horse += (cow + 2 * tuna);

  // At this point horse should have a value of 0x6824b
 
  return 0;
}

int shark(int arg0, int arg1, int arg2, int arg3)
{
  // Hint: This is a nonleaf procedure, so it needs a stack frame,
  // and you will have to make copies of the incoming arguments so
  // that a-registers are free for outgoing arguments.

  // Instructions: Normally you would have a lot of freedom within the
  // calling conventions about what s-registers you use, and about where
  // you put copies of incoming arguments, but in this exercise you
  // must copy arg0 to $s0, arg1 to $s1, arg2 to $s2, and arg2 to $s3, 
  // and use $s4 for red, $s5 for blue, and $s6 for green.

  int red, blue, green;
  blue = whale(arg2, arg1);
  green = whale(arg3, arg0);
  red = whale(arg1, arg3);

  return red + blue + green;
}

int whale(int cat, int dog)
{
  // Hint: this is a leaf procedure, and it shouldn't need to use any
  // s-registers, so you should not have use the stack at all.
  return dog + 64 * cat;
}
