/* M_times_w_sub.c

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
#include <pthread.h>

#include "M_times_w.h"

#define NTHREADS (12)

struct thread_info {
    int thread_num;
    double *Y, *a, *v, *f, *vals, *D, *w;
    int nTheta, nVoxels, nCoeffs;
    int stride, startIdx, endIdx;
    pthread_t thread_id;
};

static void *func_Mtimes(void *inarg)
{   
    int
        k, i, ai, vi, wi;
    double
        val;
    struct thread_info *arg = (struct thread_info *)inarg;

    for (k = arg->startIdx; k < arg->endIdx; k=k+1) 
    {    
        ai = (int)(arg->a[k]-1)*arg->nTheta;
        vi = (int)(arg->v[k]-1)*arg->nTheta;
        wi = arg->w[(int)(arg->f)[k]-1];
        val = wi * (arg->vals)[k];

        for (i = 0; i < arg->nTheta; i++)
        {
            arg->Y[vi+i] = arg->Y[vi+i] + arg->D[ai+i]*val;
        }       
    }
    return NULL;
}

void M_times_w_sub( double YPtr[], double atomsPtr[], double voxelsPtr[], double fibersPtr[], double valuesPtr[], double DPtr[], double wPtr[], int nTheta, int nVoxels, int nCoeffs )
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
        tinfo[t].nVoxels = nVoxels;
        tinfo[t].nCoeffs = nCoeffs;
        
        tinfo[t].startIdx = blockSize * t;
        tinfo[t].endIdx = blockSize * (t+1);
        if (t == nThreads-1)
            tinfo[t].endIdx = nCoeffs;
        tinfo[t].stride = 1;
    }
    for (t = 0; t < nThreads; t++)
    {
        s = pthread_create(&tinfo[t].thread_id, NULL, &func_Mtimes, &tinfo[t]);
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
    


