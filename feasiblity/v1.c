/* Construct a 256-bit vector from 4 64-bit doubles. Add it to itself
 * and print the result.
 */

#include <stdio.h>
#include <immintrin.h>

int main() {

  // Construction from scalars or literals.
  __m256 a = _mm256_set_ps(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0);

  // Does GCC generate the correct mov, or (better yet) elide the copy
  // and pass two of the same register into the add? Let's look at the assembly.
  __m256 b = a;

  // Add the two vectors, interpreting the bits as 4 single-precision
  // floats.
  __m256 c = _mm256_add_ps(a, b);

  // Do we ever touch DRAM or will these four be registers?
  __attribute__ ((aligned (32))) float output[8];
  _mm256_store_ps(output, c);

  printf("%f %f %f %f %f %f %f %f\n",
         output[0], output[1], output[2], output[3],
         output[4], output[5], output[6], output[7]);
  return 0;
}
