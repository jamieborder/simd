import std.stdio;
import core.simd;

void main()
{
    double4 a = 3.0;
    double4 b = 2.0;
    double4 c;
    // float4 a = 3.0;
    // float4 b = 2.0;
    // float4 c;

    writeln("a = ", a);
    writeln("b = ", b);

    // vector addition of 
    // c = __simd(XMM.ADDPD, a, b);
    asm {
        // lddqu YMM0,
        addpd YMM0, YMM1;
        // addpd XMM0, XMM1;
    }
    writeln("c = ", c);

    // return;
}
