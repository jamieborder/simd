import std.stdio;
void main()
{
    for (int i=0; i<8; ++i) {
        // writefln("%d : %d", i, bitReverse(i,31));
        writefln("%d : %d", i, bitReverse(i,7));
    }
}
int bitReverse(int i, int size)
{
    import std.algorithm.mutation: reverse;
    import std.format: format;
    import std.conv: to, parse;

    string fmt = format!"%%0%db"(size);
    auto ss = format(fmt, i);
    string st = ss.dup().reverse;
    int pst = parse!int(st, 2);
    return pst;
}
