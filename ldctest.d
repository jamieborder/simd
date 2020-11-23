import std.stdio: writeln;
import core.simd;
import ldc.simd;

int main()
{
    float4 a,b,c;

    a = 2;
    b = 3;

    c = __builtin_ia32_addps(a, b);

    writeln(c);
}
