# Main function is BrainMap
# Most important parameters are BOLD, prior, and TR

# BOLD which is the user's data for Human Connectome Project can be found in slate
# For each subject there are two paths you can use:
# /N/project/hcp_dcwan/<subject_id>/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii
# /N/project/hcp_dcwan/<subject_id>/MNINonLinear/Results/rfMRI_REST1_RL/rfMRI_REST1_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii

# For the prior you can download it from here: https://osf.io/k6vx8/overview?view_only=b614888e9aca42999ee75eb2c3e02877
# Example: priors/GICA15/prior_combined_GICA15_GSR.rds

# TR = 0.72 for HCP data

run_brainmap_for_subject <- function(bold, prior, scrubbing, smoothing, output_dir) {
  # run_brainmap_for_subject <- function(prior_path, subject) {
  prior_path <- prior
  
  bm_dir <- file.path(output_dir)
  dir.create(bm_dir, recursive = TRUE, showWarnings = FALSE)
  
  if(scrubbing){
  
    cat("Running scrubbing for bold timeseries...", "\n")
  
    # read cifti files
    bold_cifti <- lapply(bold, read_cifti)
    
    # projection scrub
    scrubbing_results <- lapply(bold_cifti, scrub_xifti)
    
    scrub = lapply(scrubbing_results, `[[`, "outlier_flag")
  
  }
  
  bMap <- BrainMap(
    BOLD = bold,
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


# Select parameters
# output directory 
output_dir <- "~/Documents/GitHub/BayesianBrainMapping-priors/data_OSF/outputs/brain_map"

# BOLD timeseries
bold1 <- file.path(dir_data, "inputs", "rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii")
bold2 <- file.path(dir_data, "inputs", "rfMRI_REST2_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii")

bold <- c(bold1, bold2)

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
X = as.matrix(read_cifti(BOLD))
BOLD_cifti = read_cifti(BOLD)



bMap = run_brainmap_for_subject(bold, prior, scrubbing = TRUE, smoothing = FALSE, output_dir = output_dir)

