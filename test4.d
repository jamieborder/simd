import core.simd;
import core.cpuid;
import std.stdio;

void main()
{
    byte b;
    writeln(b.sizeof);
    writeln(b.max);
    writefln("%08b", b);

    // byte32 c;
    // writeln(c.sizeof);
    // writeln(c.max);
    // writefln("%(%08b %)", c);


    static if (is(Vector!(byte[16]))) {
        pragma(msg, "byte[16] exists");
    }
    static if (is(Vector!(byte[32]))) {
        pragma(msg, "byte[32] exists");
    }
    if (avx2()) {
        writeln("avx2 supported");
    }
    else {
        writeln("avx2 is not supported");
    }

    version (D_AVX) {
        writeln("D_AVX");
    }
    version (D_AVX2) {
        writeln("D_AVX2");
    }
}
