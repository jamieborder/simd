import std.stdio;
import core.simd;

void main()
{
    float4 a;
    a = 3.;
    float4 b;
    b = 2.;

    writeln(a);
    writeln(b);

    float4 c;
    // vector addition of 
    c = __simd(XMM.ADDPS, a, b);
    writeln(c);

    int4 d;
    d = -4;

    writeln(d);
    // vector packed ABS doubles
    d = __simd(XMM.PABSD, d);
    writeln(d);

    short8 e;
    e = -5;

    writeln(e);
    // vector packed ABS words
    e = __simd(XMM.PABSW, e);
    writeln(e);

    byte16 f;
    f = -6;

    writeln(f);
    // vector packed ABS bytes
    f = __simd(XMM.PABSB, f);
    writeln(f);


    return;
}
