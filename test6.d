import std.stdio;
import core.simd;

void main()
{
    version (D_SIMD) {
        pragma(msg, "using D_SIMD");
    }
    else {
        pragma(msg, "not using D_SIMD");
    }
    version (D_AVX) {
        pragma(msg, "using D_AVX");
        byte32 b;
        writeln(b);
        writefln("%(%b, %)", b);
        writeln(b.length);
    }
    else {
        pragma(msg, "not using D_AVX");
        byte16 b;
        writeln(b);
        writeln(b.length);
    }

    version (D_AVX2) {
        pragma(msg, "using D_AVX2");
        byte32 c;
        writeln(c);
        double4 dd;
        writeln(dd);
    }
    else {
        pragma(msg, "not using D_AVX2");
    }
}
