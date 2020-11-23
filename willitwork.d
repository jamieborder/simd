import std.stdio;

void main()
{
    // AVX2 --> 256-bit
    // 32 x 8-bit
    // 32 x 1-byte...
    writeln("byte.min = ", byte.min); // -127
    writeln("byte.max = ", byte.max); //  128

    writeln("ubyte.min = ", ubyte.min); //   0
    writeln("ubyte.max = ", ubyte.max); // 255
}
