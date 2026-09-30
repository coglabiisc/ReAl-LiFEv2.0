/* Mtransp_times_b_sub.c

   ----------------------------------------------------------------------
   This file is part of LiFE toolbox

   Copyright (C) 2015 Cesar Caiafa & Franco Pestilli
   ----------------------------------------------------------------------
*/

#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <float.h>     /* provides DBL_EPSILON */
#include <sys/types.h>

#include "Mtransp_times_b.h"

#define NTHREADS (12)

struct thread_info {
    int thread_num;
    double *Y, *a, *v, *f, *vals, *D, *w, *fO;
    int nTheta, nVoxels, nCoeffs;
    int stride, startIdx, endIdx;
    pthread_t thread_id;
};


void *func_Mtransp(void *inarg)
{   int
        l, k, i, ai, vi;
    double
        val;
    struct thread_info *arg = (struct thread_info *)inarg;
    double dotRes;

    for (l = arg->startIdx; l < arg->endIdx; l=l+1)
    {
        k = arg->fO[l];
        val = 0;
        ai = (int)(arg->a[k]-1)*arg->nTheta;
        vi = (int)(arg->v[k]-1)*arg->nTheta;
        
        for (i = 0; i < arg->nTheta; i++)
        {
            val = val + arg->D[ai+i]*arg->Y[vi+i];
        }
        val = val*arg->vals[k];
        arg->w[(int)arg->f[k]-1] = arg->w[(int)arg->f[k]-1] + val;
    }
    return;
}

void Mtransp_times_b_sub (double wPtr[], double atomsPtr[], double voxelsPtr[], double fibersPtr[], double valuesPtr[], double DPtr[], double YPtr[], int nFibers, int nTheta, int nCoeffs, double fOrder[])
{
    int s, t;
    struct thread_info *tinfo;
    int nThreads = NTHREADS;
    void *res;
    int blockSize;

    tinfo = calloc(nThreads, sizeof(struct thread_info));

    blockSize = nCoeffs/nThreads;
    for (t = 0; t < nThreads; t++)
    {
        tinfo[t].thread_num = t;
        tinfo[t].Y = YPtr;
        tinfo[t].a = atomsPtr;
        tinfo[t].f = fibersPtr;
        tinfo[t].v = voxelsPtr;
        tinfo[t].vals = valuesPtr;
        tinfo[t].D = DPtr;
        tinfo[t].w = wPtr;
        tinfo[t].nTheta = nTheta;
        /*tinfo[t].nVoxels = nVoxels;*/
        tinfo[t].nCoeffs = nCoeffs;

        tinfo[t].fO = fOrder;
        
        tinfo[t].startIdx = blockSize * t;
        tinfo[t].endIdx = blockSize * (t+1);
        if (t == nThreads-1)
            tinfo[t].endIdx = nCoeffs;
        tinfo[t].stride = 1;
    }
    for (t = 0; t < nThreads; t++)
    {
        s = pthread_create(&tinfo[t].thread_id, NULL, &func_Mtransp, &tinfo[t]);
        if (s != 0)
        {
            printf("Failed to launch thread %d\n", t);
            exit(1);
        }
    } 
    for (t = 0; t < nThreads; t++)
    {
        s = pthread_join(tinfo[t].thread_id, &res);
        if (s != 0)
        {
            printf("Failed to join thread %d\n", t);
            exit(1);
        }
    }
    free(tinfo);
}    
