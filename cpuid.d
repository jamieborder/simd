import std.stdio;
import core.cpuid;

string res(const bool b)
{
    return b ? "true" : "false";
}

void main()
{
    writefln("mmx   : %s", res(mmx   ()));
    writefln("sse   : %s", res(sse   ()));
    writefln("sse2  : %s", res(sse2  ()));
    writefln("sse3  : %s", res(sse3  ()));
    writefln("ssse3 : %s", res(ssse3 ()));
    writefln("sse41 : %s", res(sse41 ()));
    writefln("sse42 : %s", res(sse42 ()));
    writefln("sse4a : %s", res(sse4a ()));
    writefln("aes   : %s", res(aes   ()));
    writefln("fma   : %s", res(fma   ()));
    writefln("avx   : %s", res(avx   ()));
    writefln("avx2  : %s", res(avx2  ()));
}
