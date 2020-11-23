extern(C) void run_FWT_SIMD(const int Pa, const int Na, const int N,
        const float *fi, float *Fa, const int *seq);

import std.stdio;

void main()
{
    float[] fi;
    float[] Fa;
    int[] seq;

    int Pa = 3;
    int Na = 8;

    int N = 10 * Na;

    seq.length = N;
    fi.length = N;
    Fa.length = N;

    for (int i=0; i<N; ++i) {
        seq[i] = i;
        fi[i] = i* 1.0f;
    }


    run_FWT_SIMD(Pa, Na, N, &(fi[0]), &(Fa[0]), &(seq[0]));

    writeln("Fa = ", Fa);

}
