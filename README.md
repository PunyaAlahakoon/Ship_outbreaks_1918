# Ship_outbreaks_1918

This folder contains all the codes and files used in the paper:
How effective were Australian Quarantine Stations in mitigating transmission aboard ships during the influenza pandemic of 1918-19? 

By 
Punya Alahakoon,  Peter Taylor, and James McCaw,

**Software used:** MATLAB version 2018 or higher, R 4.0 or higher 

The folder structure, what they contain, and which files to run are outlined below: 

To run the codes, please run the files specified as "RUN" to run the codes. 

1)	**Ship_assumptions_and_comments:** This folder contains the dox files generated to comment on the assumptions and the other details of the ships
There’s a Word file named after each ship. Each file contains a screenshot from the original record. And every assumption we made to each line of the record. 

2)	plausible regions: this folder contains the analyses done to identify plausible regions to enable parameter estimation. Each folder contains the analysis for each ship. 
There’s a folder for each ship. RUN: latin_squre_design.m files 

3)	**parameter_estimation:** This folder contains the hierarchical parameter estimation done using the two-step algorithm in the paper
    Alahakoon, P., McCaw, J. M., & Taylor, P. G. (2022). Estimation of the probability of epidemic fade-out from multiple outbreak data. Epidemics, 38, 100539.
  	There are sub-folders for each step of the algorithm.
        a.	Step 1. a) independent estimation : 
        There’s  a folder for each ship. 
        RUN: abc_smc_Medic4.m, abc_smc_Boonah.m, abc_smc_Devon.m, abc_smc_Manuka.m in each folder for Medic, Boonah, Devon, and Manuka respectively. 
        All the other functions will be called from these files. 
        b.	Step1. b) hyper-parameter estimation
        RUN the mcmc3.R file to estimate the hyperparameters
        c.	Step2) Ship-specific parameter estimation
        Each ship has a separate folder. 
        RUN Step2_Medic.m, Step2_Boonah.m, Step2_Devon.m, Step2_Manuka.m for each ship. All the other functions are called from these files. 

4)	**Re-sampled paths:** This folder contains the resampled paths done for Medic and Boonah. There is a separate folder for each ship. 
RUN: predictions.m (all the other functions are called within this file)

5)	**R_nought: ** the calculations for estimating r_0 of the ships sung the estimated parameters under the hierarchical framework. 
RUN: calc_R_0_ships.m (all the other files are called within this file)

6)	**Data_analysis_in_R**: all the codes used to produce figures for the manuscript and the supplements are included in this folder. There are a few sub-folders. 
        a.	Data_analysis_in_R/Ship_snapshots:
        RUN the names of the files after each ship to generate the snapshot. 
        b.	Data_analysis_in_R/Conditional_resampled_vs_resampled_paths:
        RUN the file to generate the file with conditional re-sampled and re-sampled paths. 
        c.	Data_analysis_in_R/Boonah_counterfactual_analysis: 
                1.	RUN: 5)boonah_predicted_inetrvention_analysis.R: counterfactual analysis for re-sampled paths for passengers
                2.	RUN: 6)boonah_accepted_inetrvention_analysis.R: counterfactual analysis for conditional re-sampled paths for passengers 
                3.	RUN: 5_1)boonah_predicted_crew.R: counterfactual analysis for re-sampled paths for crew
                4.	RUN: 6_1)boonah_accepted_crew_paths.R: counterfactual analysis for conditional re-sampled paths for crew
                5.	RUN: 5_2)Boonah_predicted_deaths.R, 6_2)Boonah_accepted_deaths.R: counterfactual analysis for deaths 
        d.	Data_analysis_in_R/Medic_counterfactual_analysis:
                1.	RUN:4)medic_accepted_intervention.R: counterfactual analysis for conditional re-sampled paths
                2.	RUN: 3) medic_predicted_intervention_analysis.R: counterfactual analysis for re-sampled paths
                3.	RUN: 3_1)medic_predicted_passengers.R: : counterfactual analysis for re-sampled paths for passengers 
                4.	RUN: 4_1)medic_accepted_passengers.R: counterfactual analysis for conditional re-sampled paths for passengers 
                5.	RUN: 3_3)Medic_predicted_deaths.R, 4_3)medic_accepted_deaths.R: counterfactual analysis for deaths 
        e.	Data_analysis_in_R/Visualise_hyper_parameters:
                RUN: 1)Analyse_hyper_betas.R to visualise hyper-parameters 
        f.	Data_analysis_in_R/transmission_rates:
                RUN: 1)B_correlation_matrix.R to generate the correlation matrix figure of hyperparameters 
        g.	Data_analysis_in_R/plot_all_the_posterior_distributions:
                RUN:  Run the file under each ship name to plot all the posteriors for each ship 




