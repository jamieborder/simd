import core.simd;
import std.stdio;

void main()
{
    float4 f4, f4b;
    int4 i4;
    short8 s8;

    f4.array[0] = 3;
    f4.array[] = 4;
    
    f4b.array[] = 7;

    writeln(i4);
    writeln(s8);

    writeln(f4);
    writeln(f4b);

    auto f = f4 + f4b;

    writeln(f);

    auto e = f4 * f4b;

    writeln(e);

    auto g = f4 / f4b;

    writeln(g);

    s8.array[] = 8;

    writeln("s8: ", s8);

    i4 = s8;

    writeln("i4: ", i4);

    writefln("%(%016b %)", s8);
    writefln("%(%032b %)", i4);

    writeln("s8:    ", s8.sizeof);
    writeln("short: ", short.sizeof);
    writeln("i4:    ", i4.sizeof);
    writeln("int:   ", int.sizeof);

    // short -> 2 bytes -> 16 bits
    // short8 -> 16 bytes -> 128 bits
    // 0000000000001000 0000000000001000 0000000000001000 0000000000001000
    // 0000000000001000 0000000000001000 0000000000001000 0000000000001000

    // int -> 4 bytes -> 32 bits
    // int4 -> 16 bytes -> 128 bits
    // 00000000000010000000000000001000 00000000000010000000000000001000
    // 00000000000010000000000000001000 00000000000010000000000000001000
}
