# Packages must be installed and loaded into R
# install.packages("BayesBrainMap")
#remove.packages("BayesBrainMap")
#devtools::install_github("mandymejia/BayesBrainMap", "2.0")
library(BayesBrainMap)
#install.packages("ciftiTools") 
#library(BayesBrainMap)
library(ciftiTools)

run_brainmap_for_subject <- function(bold, prior, scrubbing, smoothing) {
  # run_brainmap_for_subject <- function(prior_path, subject) {
  prior_path <- prior
  base_dir   <- "/N/project/clubneuro/MSC/washu_preproc/surface_pipeline"
  output_dir <- "~/Documents/GitHub/BayesianBrainMapping-priors/data_OSF/outputs/brain_map"
  
  bm_dir <- file.path(output_dir)
  dir.create(bm_dir, recursive = TRUE, showWarnings = FALSE)
  
  bold_file <- bold 
  
  cat("Running engagements for", subject, session, "\n")
  
  scrub_BOLD1 <- replicate(length(BOLD_paths1), T_scrub_start:nT_HCP, simplify = FALSE)
  scrub_BOLD2 <- replicate(length(BOLD_paths2), T_scrub_start:nT_HCP, simplify = FALSE)
  scrub <- list(scrub_BOLD1, scrub_BOLD2)
  

  
  bMap <- BrainMap(
    BOLD = bold_file,
    prior = prior_path,
    TR = TR_HCP,
    drop_first = 5,
    hpf = 0,
    GSR = FALSE,
    scrub = scrub,
    usePar = nThreads
  )
  
  saveRDS(bMap, file.path(bm_dir, paste0(subject, "_", session, "_bMap.rds")))
  
  eng <- engagements(
    bMap,
    z = 5,
    method_p = "bonferroni"
  )
  
  saveRDS(eng, file.path(bm_dir, paste0(subject, "_", session, "_engagements_bon_z5.rds")))
  
  cat("Finished subject", subject, "session", session, "\n")
}


# Set CIFTI Workbench path (download from https://www.humanconnectome.org/software/connectome-workbench)
wb_path <- "~/Downloads/workbench" # path to where you downloaded it
ciftiTools.setOption("wb_path", wb_path) 

# Main function is BrainMap
# Most important parameters are BOLD, prior, and TR

# BOLD which is the user's data for Human Connectome Project can be found in slate
# For each subject there are two paths you can use:
# /N/project/hcp_dcwan/<subject_id>/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii
# /N/project/hcp_dcwan/<subject_id>/MNINonLinear/Results/rfMRI_REST1_RL/rfMRI_REST1_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii

# For the prior you can download it from here: https://osf.io/k6vx8/overview?view_only=b614888e9aca42999ee75eb2c3e02877
# Example: priors/GICA15/prior_combined_GICA15_GSR.rds

# TR = 0.72 for HCP data

# Load BOLD data 
BOLD <- file.path(dir_data, "inputs", "rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii")

# Select prior through nIC encoding (specified in 5_estimate_prior.R)
nIC <- 0
prior <- if (nIC == 0) {
  file.path(dir_project, "priors", "Yeo17", "prior_combined_Yeo17_noGSR.rds")
} else if (nIC == 1) {
  file.path(dir_project, "priors", "MSC", "prior_combined_MSC_noGSR.rds")
} else if (nIC == 2) {
  file.path(dir_project, "priors", "PROFUMO", "prior_combined_PROFUMO_noGSR.rds")
} else {
  file.path(dir_project, "priors", sprintf("GICA%d", nIC), paste0("prior_combined_", sprintf("GICA%d", nIC), "_noGSR.rds"))
}

# Start scrubbing
# read BOLD timeseries as matrix 

BOLD_cifti = read_cifti(BOLD)
BOLD_mat = as.matrix(BOLD_cifti)

# projection scrub
scrubing_results = scrub_xifti(BOLD_cifti)

# perform scrubbing 
BOLD_scrubbed = BOLD_cifti[,scrubing_results[4]$outlier_flag]

# save results
write_cifti(BOLD_scrubbed, paste0(BOLD, "_scrubbed"))


