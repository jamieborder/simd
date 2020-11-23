
import std.stdio;
import std.math: sin;
import std.datetime: MonoTime;
import std.conv: to;

void main(string[] args)
{
    int numFWTs = 1;
    int Pa = 5;
    int verb = 0;
    int numRuns = 10;

    immutable string helpStr =
        "./fwt [numFWTs, [Pa, [verbosity, [numRuns]]]]";
    if (args.length > 1) {
        scope(failure) writeln(helpStr);
        numFWTs = to!int(args[1]);
        if (args.length > 2) {
            Pa = to!int(args[2]);
            if (args.length > 3) {
                verb = to!int(args[3]);
                if (args.length > 4) {
                    numRuns = to!int(args[4]);
                }
            }
        }
    }

    int Na = 2^^Pa;
    int N  = numFWTs * Na;

    // generate fake fi data, and empty Fa data
    // (real data given by discrete function data (fi),
    //  modified as such:
    //   f = fi * dx / sqrt(xb - xa) ... (TODO) )
    float[] fi, Fa_SHFL, Fa_GM, Fa_SM;
    fi.length = N;
    Fa_SHFL.length = N;
    Fa_GM.length = N;
    Fa_SM.length = N;
    for(int i=0;i<N;i++) {
        fi[i] = sin(i*0.05);
    }



    /// ----- cpu -----
    float[] Fa_cpu;
    Fa_cpu.length = N;

    auto startTime = MonoTime.currTime;
    for(int i=0;i<N;i+=Na) {
        Fa_cpu[i..i+Na] = FWT_fiToFaFromPoints(Pa, Na,
            0.0, 1.0, fi[i..i+Na]);
    }
    auto cpuTime = MonoTime.currTime - startTime;


    writeln("Fa_cpu = \n", Fa_cpu);
}


// If using an extended domain, probably need to adjust accordingly - change d_x,
//  x_a, x_b, x_midPoints.
float[] FWT_fiToFaFromPoints(in size_t p_a, in size_t N_a,
        in float x_a, in float x_b, float[] fiCopy)//fiAtMidPoints)
{
    // size_t N_a = 2^^p_a;
    // float d_x = (x_b - x_a) / N_a;
    float[] F_currBlock, F_prevBlock;
    F_currBlock.length = N_a;
    F_prevBlock.length = N_a;

    // float[] fiCopy = fiAtMidPoints.dup();

    // foreach(ref fi; fiCopy) {
        // fi = fi * d_x / sqrt(x_b - x_a);
    // }

    size_t i1, i2, i3;
    // Block 1.
    foreach(a; 1 .. N_a / 2 + 1) {
        i1 = 2 * a - 1;
        i2 = i1 + 1;

        F_currBlock[i1 - 1] = fiCopy[i1 - 1] + fiCopy[i2 - 1];
        F_currBlock[i2 - 1] = fiCopy[i1 - 1] - fiCopy[i2 - 1];
    }
    F_prevBlock = F_currBlock.dup();
    // Block(s) 2 --> p_a.
    foreach(p_m; 2 .. p_a + 1) {
        size_t N_pm = 2^^p_m;
        foreach(G; 1 .. N_a / N_pm + 1) {
            // solving top
            foreach(a; 1 .. N_pm / 2 + 1) {
                i1 = a + (G - 1) * N_pm;
                i2 = 2 * a - 1 + (G - 1) * N_pm;
                i3 = i2 + 1;
                
                F_currBlock[i2 - 1] = F_prevBlock[i1 - 1];
                F_currBlock[i3 - 1] = F_prevBlock[i1 - 1];
            }
            // solving bottom
            foreach(a; 1 .. N_pm / 2 + 1) {
                i1 = N_pm + 1 - a + (G - 1) * N_pm;
                i2 = N_pm + 2 - 2 * a + (G - 1) * N_pm;
                i3 = i2 - 1;
                long theta = to!long((-1.)^^(a + 1));

                F_currBlock[i2 - 1] = F_currBlock[i2 - 1] + theta * F_prevBlock[i1 - 1];
                F_currBlock[i3 - 1] = F_currBlock[i3 - 1] - theta * F_prevBlock[i1 - 1];
            }
        }
        F_prevBlock = F_currBlock.dup();
    }
    return F_currBlock;
}
