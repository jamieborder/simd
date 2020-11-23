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
    }
    else {
        pragma(msg, "not using D_AVX");
        byte16 b;
        writeln(b);
    }
}
