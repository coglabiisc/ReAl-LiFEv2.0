**Dependencies:** Vistasoft and Matlab Brain Anatomy (MBA) must be downladed and added to path prior to running ReAl-LiFE. These can be found in the links below:  

Vistasoft: https://github.com/vistalab/vistasoft  
MBA: https://github.com/francopestilli/mba

To run **ReAl-LiFE** on any dataset, simply run the script **real_life.m**.  

This script takes the following input arguments:

1. *use_gpu*: 1 to use GPU and 0 to use CPU.
2. *tck_file*: name of tract file (in .tck MRtrix format). Sample file for 1 million connectome is available in /data/demo data/WB_1M.tck.
3. *Niter*: Number of iterations for the optimization algorithm.
4. *lambda*: Value regularization parameter.
5. *alpha*: Type of regularization (1 for L1 and 0 for L2).
6. *gpudev*: The gpu device to be used, usually a positive integer.

To reproduce the results presented in figures 1-5, please follow the instructions below:

**Figure 1:**  
Run the script named **reproduce_1.m**.  
This script calls **real_life_fig1.m** to run CPU-LiFE and GPU-LiFE on datasets H, I and S, for varying values of the connectome size N_f. It extracts the execution time and computes speedups, plotting figures similar to **Fig. 1C** in the main text.

**NOTE:** Any discrepancy in CPU and GPU runtimes can be attributed to the differences in CPU and GPU hardware. The speedups presented in the paper have been tested using the following configutation    
    
    CPU: 8 cores Intel(R) Xeon(R) CPU E5-2623 v3 @ 3.00GHz  
    GPU: 1 NVIDIA GeForce GTX 1080 Ti,  
    
while the configuration of the Code Ocean environment is as follows:  

    CPU: 4 cores Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz  
    GPU: 1 NVIDIA Tesla K80,     


**Figure 2:**  
To reproduce Fig. 2B, run  **reproduce_2B.m**.  
This script calls **real_life_fig2b.m** to run LiFE and ReAl-LiFE and saves the resultant fiber weights. Further, it calls the script Fig_2B to compute the similarity index zeta after LiFE, ReAl-LiFE and SIFT2 pruning, plotting the heatmaps similar to **Fig. 2B** in the main text.

To reproduce Fig. 2C-D, run **reproduce_2CD.m**.  
This script calls **real_life_fig2cd.m** to run LiFE (lambda=0) and ReAl-LiFE (30 lambda values, L1 regularization) and saves the resultant sum of fiber weights and cross-validated RMS error. Further, it calls the scripts **Fig_2C.m** and **Fig_2D.m** to plot the summed weights and cross-validated RMSE as a function of regularization parameter lambda, similar to **Fig. 2C** and **Fig. 2D** in the main text, for datasets S(ET), I, and M.

**Figure 3:**  
To reproduce Fig. 3C and Fig. 3D, run **reproduce_3CD.m**.  
This script calls **real_life_fig3cd.m** to run the test for overfitting and consistency after pruning with LiFE and ReAl-LiFE. Further it calls the scripts **Fig_3C.m** and **Fig_3D.m** to plot the voxelwise difference in RMS errors post pruning with LiFE and ReAl-LiFE as in **Fig. 3C-D**.  

To reproduce Fig. 3E and Fig. 3F, run **reproduce_3EF.m**.  
This script calls **real_life_fig3ef.m** to run the ReAl-LiFE with L1 and L2 regularizations. Further it calls the scripts **Fig_3E.m** and **Fig_3F.m** to plot the L1 and L2 norm of weights versus the cross-valideated RMS error for each regularization type as in **Fig. 3E-F**.  

**Figure 4:**  
*Reproducing Fig. 4 requires additional tools and softwares such as MRtrix3 and the ISMRM Tractometer tools. Please find more information below:*  

The script **reproduce_4.m** helps to run ReAl-LiFE on the different parts of the 25 million connectome (10 parts, 2.5 million each). Next, combine the pruned parts. This step requires the **tckedit** command in MRtrix3 (https://www.mrtrix.org). The following lines of code serve as a template and can be used in MATLAB after installing MRtrix3:  
  
*cmd = 'tckedit -force';**  

*for ii = 1:10*  
    *cmd = sprintf('%s /data/Fig_4/raw_data/WB_25M_RL_p%d.tck',cmd,ii);*  
*end*  

*cmd = sprintf('%s /data/Fig_4/raw_data/WB_ReAl-LiFE_part10_combined.tck',cmd);*  
*system(cmd);*  

The combined connectomes after pruning with ReAl-LiFE and SIFT are presently avaliable as **WB_ReAlLiFE_part10_combined.tck** and **WB_SIFT_part10_combined.tck**, in the **/data/Fig_4/raw_data/** folder.

To obtain overlap and overreach for each valid bundle after pruning, pass the ReAl-LiFE pruned and SIFT pruned connectomes through the scoring tool provided in Maier-Hein et al, 2017 (https://www.nature.com/articles/s41467-017-01285-x). See https://github.com/scilus/ismrm_2015_tractography_challenge_scoring for details on how to score tractograms. Ensure that the valid and invalid bundles are extracted and saved using the *--save_vb* and *--save_ib* arguments.

To reproduce Fig. 4B, run the script **Fig_4B.m**.

To reproduce Fig. 4D, run the script **Fig_4D.m**. This script plots the distance distributions for the left SLF post pruning with ReAl-LiFE and SIFT.

To reproducce Fig. 4F, execute the script **Fig_4F.m**. This script plots the histogram distances as in **Fig. 4F**, main text.  

**Figure 5:**  
Feature matrices and scripts for running the regression model are provided in the folder **/code/ReAl-LiFE Reproducibility/Fig_5/**. The main script to do the predictions using the unpruned and ReAl-LiFE features are **RegerssionAnalyses_RFE_Unpruned.m** and **RegerssionAnalyses_RFE_ReAlLiFE.m**, respectively. All 60 scores are provided in the file **/data/Fig_5/raw_data/Scores_200_60.mat**.  

Additionally, Figure 5 can be reproduced using pre-existing data and scripts **Fig_5B**, **Fig_5CE**, **Fig_5G**.









