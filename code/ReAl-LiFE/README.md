## Rapid and accurate discovery of individualized brain connectomes on GPUs

## ABOUT

This software implements a Regularized and GPU-accelerated version of LiFE. The original implementation of LiFE is available at https://github.com/brain-life/encode

## LICENSE

#### Copyright (2021-), Sawan Kumar (sawankumar@iisc.ac.in), Varsha Sreenivasan (varshas@iisc.ac.in), Devarajan Sridharan (sridhar@iisc.ac.in)

## FUNDING
This research was funded by MHRD, Govt. of India (to Sawan Kumar, Varsha Sreenivasan); a Wellcome Trust-Department of Biotechnology India Alliance Intermediate fellowship [IA/I/15/2/502089]; a Science and Engineering Research Board Early Career award; a Pratiksha Trust Young Investigator award [ECR/2016/000403]; a Department of Biotechnology-Indian Institute of Science Partnership Program grant; an India Trento Partnership Program grant (all to Devarajan Sridharan).

------------------------------------------------------------------------------------------------------

## SYSTEM REQUIREMENTS

# Hardware dependencies
All results presented in the paper (CPU and GPU) were obtained using a single machine with specifications as described below. The machine had 8 Intel(R) Xeon(R) CPU E5-2623 v3 @ 3.00GHz processors and 1 NVIDIA GeForce GTX 1080 Ti GPU card. For our experiments we used only 1 CPU and 1 GPU. The machine had a total of 64GB  DDR4 system memory. The DDR4 configuration was 4x16GB 1866 MHz. The GPU cards were configured to have persistence mode enabled. The total hard disk space available was 447 GB, out of which 64 GB was configured as swap.

# Software dependencies
1. Ubuntu 16.04
2. MATLAB R2017b 64-bit
3. CUDA toolkit 9.0
4. The GPU code binaries were built using the ``nvcc'' compiler with the flag ``-ptx''.

Our code is built on top of the original LiFE code at https://github.com/brain-life/encode. The prerequisites as mentioned there also apply for our code and are as follows:
1. Vistasoft (https://github.com/vistalab/vistasoft)
2. Matlab Brain Anatomy (MBA, https://github.com/francopestilli/mba)

The code has been tested on a system with the above software and hardware configurations.

------------------------------------------------------------------------------------------------------

## INSTALLATION GUIDE

# Instructions for use
1. Download the base version of LiFE(https://github.com/brain-life/encode). ReAl-LiFE was built on top of commit 'c979e66' : https://github.com/brain-life/encode/tree/c979e664d897ff72abb62397410b472bfdea8e67 .
2. Refer to https://github.com/brain-life/encode to download and install all the dependencies mentioned there.
3. Download (real-life) into the same folder as #1. The sequence is important, as some files in #1 are updated in this step.
4. Ensure the nvcc compiler is in the PATH environment variable (This instruction is for Ubuntu machines. Update accordingly for other platforms).
5. [Start MatLab](http://www.mathworks.com/help/matlab/startup-and-shutdown.html).
6. Add repository to the [matlab search path](http://www.mathworks.com/help/matlab/ref/addpath.html).

Note: Typical intallation requires cloning the Github repositories for Vistasoft, MBA and ReAl-LiFE. Installation should not take more 15 minutes.

------------------------------------------------------------------------------------------------------

## DEMO

# Instructions to run ReAl LiFE on demo data
(scripts/real/real_life.m)
Run 'help real_life' for details in the arguments to be used

For the demo data provided with the code, ReAl-LiFE for 500 iterations, lambda=0.01, L1 regularization (alpha=1) can be run as:

  >>  real_life(1, WB_1M.tck, 500, 0.01, alpha, gpu_device);

where gpu_device is a valid GPU device on the machine. Use gpu_device


# Expected output
On succesful completion, real_life.m saves the all model details in a matlab structure "fe". Performance numbers can be found in the output variable "out".
Additionally, the performance numbers for CPU can be obtained under "CPU: Time taken during optimization:", the output real_life printed to screen. Similarly, The performance number for GPU can be obtained under "ReAl: Time taken during optimization:". The one time GPU overhead can be obtained under "ReAl: Time taken during GPU pre-processing:".

# Expected run-time
For a typical connectome of 1 million fibers and diffusion data acquired in 64 directions, ~100,000 voxels, the run-time of CPU-LiFE (Or LiFE) can be expected to be ~3 hours, while the run-time of GPU-LiFE can be expected to be ~2 minutes.

------------------------------------------------------------------------------------------------------

## INSTRUCTIONS FOR USE

# How to run ReAl-LiFE on your data
Based on which dataset is being used and its location, the paths to diffusion data for training (dwiFile), diffusion data for cross validation (dwiFileRepeat), the anatomical MRI (t1File) and the tractography connectome to be evaluated (tck file) need to be updated.

  >>  real_life(use_gpu, tck_file,subnum, Niter, lambda, alpha, gpudev)

The baseline results (CPU) for N iterations can be evaluated by running: 

  >>  real_life(false, tckfile_name, N, 0, 0, 0)

where tckfile_name is used to identify the location of the input tractogram file.

The regularized and GPU-accelerated version with regularization parameter lambda and regularization type alpha can be evaluated by running:

  >>  real_life(true, tckfile_name, N, lambda, alpha, gpu_device)

where gpu_device is a valid GPU device on the machine.

Further details on all arguments can be obtained by running "help real_life" in MATLAB. Use gpu_device according to system specifications.

# Reproduction instructions
Performance numbers can be found in the output variable "out".
Additionally, the performance numbers for CPU can be obtained under "CPU: Time taken during optimization:", the output real_life printed to screen. Similarly, The performance number for GPU can be obtained under "ReAl: Time taken during optimization:". The one time GPU overhead can be obtained under "ReAl: Time taken during GPU pre-processing:".

The CPU and GPU times thus obtained can be used to reproduce the results in Figure 1. 

For both CPU and GPU, the weights can be obtained under the variable "weights", in the output of real_life.m. Additionally, these can be extracted from the "fe" structure directly as:
>> weights = fe.life.fit.weights

The training and cross-validated RMS errors can be found in the variables rmse_tr, rmse_cv, respctively. These are outputs of real_life. Additionally, these can be computed from the "fe" structure as:
>>  rmse_tr = feGet(fe, 'total rmse'); % Training error
    rmse_cv = feGetRep(fe, 'total rmse'); % Cross validation error

------------------------------------------------------------------------------------------------------

## ADDITONAL NOTES

Our speedups exceeded state-of-the-art numbers based on a recently reported MPI-acceleration scheme for LiFE [Gugnani et al. 2017]. Our baseline numbers are derived from the same configuration as Gugnani et al's "Cluster A" (single core Intel Xeon E5), enabling us to directly compare our speedup factors with theirs. In that study, the reported maximum multi-node speedups (8.1x) did not exceed the single node speedup value (8.7x), suggesting that MPI may not be an effective parallelization strategy for LiFE. On the other hand, our speedups are an order of magnitude faster (98x), indicating GPU acceleration is an effective strategy.

------------------------------------------------------------------------------------------------------

## REFERENCES
[1] Gugnani, S., Lu, X., Pestilli, F., Caiafa, C., & Panda, D. K. (2017, December). MPI-LiFE: Designing High-Performance Linear Fascicle Evaluation of Brain Connectome with MPI. In High Performance Computing (HiPC), 2017 IEEE 24th International Conference on (pp. 213-222). IEEE.
