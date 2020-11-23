/* Construct a 256-bit vector from 4 64-bit doubles. Add it to itself
 * and print the result.
 */

#include <stdio.h>
// #include <math.h>
#include <immintrin.h>

void getSequence(int *s, int Na, int P, int *seq);
int bitReverse(int i, int size);
void simd_FWT(float *fi, float *Fa, int *seq, const int Pa, const int Na);
void view8floats(__m256 a);
void view8ints(__m256i a);

int main()
{
    const int Pa = 3;
    const int Na = 2<<(Pa-1);

    float fi[Na];
    for (int i=0; i<Na; ++i) {
        fi[i] = 1.0 * i;
    }

    float Fa[Na];

    // calculate sequency mapping (same for each FWT)
    int s[Na];
    for(int i=0;i<Na;++i) {
        s[i] = i;
    }
    int seq[Na];
    getSequence(s, Na, Pa, seq);
    printf("seq = ");
    for (int i=0;i<Na;++i) {
        printf("%d ", seq[i]);
    }
    printf("\n");

    simd_FWT(fi, Fa, seq, Pa, Na);
}

void simd_FWT(float *fi, float *Fa, int *seqArr, const int Pa, const int Na)
{
    // __m256 F1[4];
    // __m256 F2[4];

    // __m256i seq[4];
    // __m256i srcMask[4];
    // __m256i negMask[4];

    // for (int i=0; i<Na; i+=8) {
        // F1[i] = __m256_set_ps(
                // fi[0+i], fi[1+i], fi[2+i], fi[3+i],
                // fi[4+i], fi[5+i], fi[6+i], fi[7+i]);
    // }

    // -----

    __m256 F1;
    __m256 F2;

    __m256i lid;
    __m256i seq;
    __m256i srcMask;
    __m256i negMask;

    __m256i a;
    __m256i one;
    __m256i two;
    __m256i negOne;
    __m256i Nm;

    one = _mm256_set1_epi32(1);
    two = _mm256_set1_epi32(2);
    negOne = _mm256_set1_epi32(-1);
    Nm = _mm256_set1_epi32(Na/2);

    // setr because Intel has it flipped
    F1 = _mm256_setr_ps(fi[0], fi[1], fi[2], fi[3], fi[4], fi[5], fi[6],
            fi[7]);

    // setr because Intel has it flipped
    seq = _mm256_setr_epi32(seqArr[0], seqArr[1], seqArr[2], seqArr[3],
            seqArr[4], seqArr[5], seqArr[6], seqArr[7]);

    view8floats(F1);
    view8ints(seq);


    // setr because Intel has it flipped
    lid = _mm256_setr_epi32(0,1,2,3,4,5,6,7);
    printf("lid = ");
    view8ints(lid);

    // a = _mm256_set1_epi32(Pa-0-1);
    // printf("a   = ");
    // view8ints(a);
    // lid = _mm256_srlv_epi32(lid, a);
    // printf("lid = ");
    // view8ints(lid);
    // printf("i >> 2\n");
    // for (int i=0; i<8; ++i) {
        // printf("%d : %d\n", i, i >> 2);
    // }
    // printf("(i >> 2) & 1LU\n");
    // for (int i=0; i<8; ++i) {
        // printf("%d : %d\n", i, (i >> 2) & 1LU);
    // }


    printf("a = ");
    view8ints(a); 
    a = _mm256_set1_epi32(Pa-0-1);

    // -- srcMask --
    // bitwise shift right by 'a'
    srcMask = _mm256_srlv_epi32(lid, a);
    view8ints(srcMask);
    // bitwise and
    srcMask = _mm256_castps_si256(
        _mm256_and_ps(_mm256_castsi256_ps(srcMask), _mm256_castsi256_ps(one)));
    view8ints(srcMask);
    // bitwise xor
    srcMask = _mm256_castps_si256(
        _mm256_xor_ps(_mm256_castsi256_ps(srcMask), _mm256_castsi256_ps(one)));
    view8ints(srcMask);


    // -- negMask --
    // bitwise shift right by 'a'
    negMask = _mm256_srlv_epi32(lid, a);
    printf("bitwise shift right by 'a'\n");
    view8ints(negMask);
    // bitwise and
    negMask = _mm256_castps_si256(
            _mm256_and_ps(_mm256_castsi256_ps(negMask), _mm256_castsi256_ps(one)));
    printf("bitwise and\n");
    view8ints(negMask);
    // mult by 2
    negMask = _mm256_mullo_epi32(negMask, two);
    printf("mult by 2\n");
    view8ints(negMask);
    // take 1
    negMask = _mm256_sub_epi32(negMask, one);
    printf("take 1\n");
    view8ints(negMask);
    // mult by neg 1
    negMask = _mm256_mullo_epi32(negMask, negOne);
    printf("mult by -1\n");
    view8ints(negMask);


    printf("F1 =\n");
    view8floats(F1);
    // -- shuffle down --
    // F2 = _mm256_mullo_epi32(srcMask,
            // _mm256_permutevar8x32_epi32(F1, Nm));
    F2 = _mm256_set1_ps(0.0f);
    printf("F2 =\n");
    view8floats(F2);
    // F2 = _mm256_permute_ps(F1, 0b00000000);
    printf("Nm =\n");
    view8ints(Nm);
    printf("lid - Nm =\n");
    view8ints(_mm256_sub_epi32(lid, Nm));
    // F2 = _mm256_permutevar8x32_ps(F1, _mm256_setr_epi32(1,1,2,3,4,5,6,7));
    F2 = _mm256_permutevar8x32_ps(F1, _mm256_sub_epi32(lid, Nm));
    printf("F2 =\n");
    view8floats(F2);

    printf("srcMask\n");
    view8ints(srcMask);
    // F2 = _mm256_mul_ps(_mm256_castsi256_ps(srcMask),
            // _mm256_permutevar8x32_ps(F1,
                // _mm256_sub_epi32(lid, Nm)));
    // printf("srcMask (8floats)\n");
    // view8floats(_mm256_castsi256_ps(srcMask));
    // __m256 srcMaskf = _mm256_castsi256_ps(srcMask);
    // printf("srcMaskf\n");
    // view8floats(srcMaskf);
    // srcMaskf = _mm256_castsi256_ps(_mm256_setr_epi32(0,1,2,3,4,5,6,7)); // this doesn't change anything, just interprets int as float
    // srcMaskf = _mm256_cvtepi32_ps(_mm256_setr_epi32(0,1,2,3,4,5,6,7)); // this does a conversion
    // printf("srcMaskf\n");
    // view8floats(srcMaskf);

    // F2 = _mm256_mul_ps(_mm256_castsi256_ps(srcMask), F2);
    F2 = _mm256_mul_ps(_mm256_cvtepi32_ps(srcMask), F2);
    printf("F2 =\n");
    view8floats(F2);

    
    // -- flip mask --
    // srcMask = _mm256_xor_epi32(srcMask, srcMask);
    srcMask = _mm256_castps_si256(
        _mm256_xor_ps(_mm256_castsi256_ps(srcMask), _mm256_castsi256_ps(one)));
    printf("srcMask\n");
    view8ints(srcMask);

    // -- shuffle up --
    F2 = _mm256_add_ps(F2,
            _mm256_mul_ps(
                _mm256_cvtepi32_ps(srcMask),
                    _mm256_permutevar8x32_ps(F1,
                        _mm256_add_epi32(lid, Nm))));
    printf("F2 =\n");
    view8floats(F2);


    // -- add to existing value using negMask --
    F1 = _mm256_add_ps(
            _mm256_mul_ps(F1,
                _mm256_cvtepi32_ps(negMask)), F2);
    printf("F1 =\n");
    view8floats(F1);


    /*
    for(int pm=0;pm<Pa;pm++) {
        // calculate src mask
        srcMask = ((tid >> (Pa-pm-1)) & 1LU) ^ 1LU; // 0 or 1

        // calculate negMask
        negMask = (((tid >> (Pa-pm-1)) & 1LU) * 2 - 1) * -1;    // 1 or -1

        // apply warp shuffle down
        F2 = srcMask * __shfl_down_sync(0xFFFFFFFF, F1, Nm);

        // flip mask
        srcMask ^= 1LU;

        // apply warp shuffle up
        F2 += srcMask * __shfl_up_sync(0xFFFFFFFF, F1, Nm);

        // add to existing warp value, using negMask
        F1 = F1 * negMask + F2;

        // update shfl width
        Nm >>= 1;
    }
    */
}

void getSequence(int *s, int N, int P, int *seq)
{
    int *g;
    g = (int *)malloc(N * sizeof(int));
    seq = (int *)malloc(N * sizeof(int));

    for (int i=0;i<N;i++) {
        g[i] = s[i] ^ (s[i] >> 1);
    }

    for (int i=0;i<N;i++) {
        seq[bitReverse(g[i], P)] = i;
    }
}

int bitReverse(int i, int size)
{
    return 1;
}
/* Ahhh it's times like these you wish you were using dlang..
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
*/

void view8floats(__m256 a)
{
    __attribute__ ((aligned (32))) float output[8];
    _mm256_store_ps(output, a);
    printf("%f %f %f %f %f %f %f %f\n",
         output[0], output[1], output[2], output[3],
         output[4], output[5], output[6], output[7]);
}

void view8ints(__m256i a)
{
    __attribute__ ((aligned (32))) int output[8];
    // _mm256_store_epi32(output, a); // only avx512..
    _mm256_store_si256(output, a);
    printf("%d %d %d %d %d %d %d %d\n",
         output[0], output[1], output[2], output[3],
         output[4], output[5], output[6], output[7]);
}
