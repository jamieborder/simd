
__global__ void FWT_SHFL(const float *fi, float *Fa, const int *seq,
        const int Pa, const int Na, const int N)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;    // thread Id

    float F1; // storing last value
    float F2; // will be shuffled, all threads have one

    int seqi; // where in memory to put value

    // calculate whether mem pull will be made neg
    // [0:1] -> [0:2] -> [-1:1] -> [1:-1]
    int negMask;

    // whether to accept shfl this round
    int srcMask;

    // every thread load first piece of data
    if (tid < N) {
        F1 = fi[tid];
    }

    // memory pull hidden by next ops
    seqi = seq[tid];

    int Nm = Na/2;
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

    // write to global memory
    if (tid < N) {
        Fa[(tid / 32) * 32 + seqi] = F1;
    }

    return;
}

