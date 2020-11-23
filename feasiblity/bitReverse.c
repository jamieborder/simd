#include <stdio.h>

int reverseBits(int num, int size);

int main()
{
    for (int i=0; i<2*8; i+=2) {
        printf("%d : %d\n", i, reverseBits(i, 8));
    }
}

int reverseBits(int num, int size) 
{ 
    // int  NO_OF_BITS = sizeof(num) * 8; 
    int NO_OF_BITS = size;
    int reverse_num = 0; 
    int i; 
    for (i = 0; i < NO_OF_BITS; i++) 
    { 
        if((num & (1 << i))) 
           reverse_num |= 1 << ((NO_OF_BITS - 1) - i);   
   } 
    return reverse_num; 
} 

