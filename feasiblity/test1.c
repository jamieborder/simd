#include <stdio.h>
#include <immintrin.h>

void view8floats(__m256 a);
void view8ints(__m256i a);

int main()
{
    __m256i a;

    __m256 F1 = _mm256_set_ps(0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0);
    __m256 F2;

    __m256i lid = _mm256_setr_epi32(0,1,2,3,4,5,6,7);

    __m256i Nm = _mm256_set1_epi32(4);

    printf("lid = \n");
    view8ints(lid);
    printf("Nm  = \n");
    view8ints(Nm);

    printf("F1  = \n");
    view8floats(F1);

    // a = _mm256_sub_epi32(lid, Nm);
    a = _mm256_add_epi32(lid, Nm);
    printf("a   = \n");
    view8ints(a );

    F2 = _mm256_permutevar8x32_ps(F1, a);

    printf("F2  = \n");
    view8floats(F2);

    a = _mm256_add_epi32(lid, _mm256_set1_epi32(4));
    printf("lid + 4  = \n");
    view8ints(a);
    a = _mm256_sub_epi32(lid, _mm256_set1_epi32(4));
    printf("lid - 4  = \n");
    view8ints(a);

    a = _mm256_add_epi32(lid, _mm256_set1_epi32(2));
    printf("lid + 2  = \n");
    view8ints(a);
    a = _mm256_sub_epi32(lid, _mm256_set1_epi32(2));
    printf("lid - 2  = \n");
    view8ints(a);


    a = _mm256_add_epi32(lid, _mm256_set1_epi32(1));
    printf("lid + 1  = \n");
    view8ints(a);
    a = _mm256_sub_epi32(lid, _mm256_set1_epi32(1));
    printf("lid - 1  = \n");
    view8ints(a);
}

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

