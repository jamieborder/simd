import core.simd;
import std.stdio; 

version(D_AVX2)
{
  string hello()
  { return("This is AVX2"); }
}
else
{
  string hello()
  { return("Sorry, no AVX2"); }
}

version(D_AVX)
{
  string hello2()
  { return("This is AVX"); }
}
else
{
  string hello2()
  { return("Sorry, no AVX"); }
}
           
void main()
{
    writeln(hello);
    writeln(hello2);
}
