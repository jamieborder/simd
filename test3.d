import std.stdio;
void main()
{
    auto a = 1LU;
    writeln(a);
    writeln(a.sizeof);

    int b = 2;
    writeln(is(typeof(b) == int));
    // writeln(is(typeof(a) == void	));
    // writeln(is(typeof(a) == bool	));
    // writeln(is(typeof(a) == byte	));
    // writeln(is(typeof(a) == ubyte	));
    // writeln(is(typeof(a) == short	));
    // writeln(is(typeof(a) == ushort	));
    // writeln(is(typeof(a) == int	));
    // writeln(is(typeof(a) == uint	));
    // writeln(is(typeof(a) == long	));
    writeln(is(typeof(a) == ulong	));
    // writeln(is(typeof(a) == float	));
    // writeln(is(typeof(a) == double	));
    // writeln(is(typeof(a) == real));
}
