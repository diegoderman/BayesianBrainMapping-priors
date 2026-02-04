#manuscript_brainmap_visualization.R


# Initialize dependencies 
sourcedir = "~/Documents/GitHub/BayesianBrainMapping-priors/src"

# Setup up dependencies and parameters
source(file.path(sourcedir, "0_setup.R"))

################################### Set parameters to look-up RDS names. ###################################################################

manuscript_output_dir <- "~/Documents/GitHub/BayesianBrainMapping-priors/manuscript"
output_dir <- file.path(manuscript_output_dir, "outputs", "brain_map")
# create output directory if it does not exist
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# set subject and session
subject_ids <- c("100307", "100206", "100408", "100610", "101107", "103111") # example subject
session_id <- c("REST1", "REST2")

# set parameters
encoding <- c("LR", "RL") 
smoothing <- 4 # in mm FWHM
scrubbing <- TRUE
# Define prior path based on selected nIC
nIC <- brainMap_prior
prior_path <- if (nIC == 0) {
  file.path(dir_project, "priors", "Yeo17", "prior_combined_Yeo17_noGSR.rds")
} else if (nIC == 1) {
  file.path(dir_project, "priors", "MSC", "prior_combined_MSC_noGSR.rds")
} else if (nIC == 2) {
  file.path(dir_project, "priors", "PROFUMO", "prior_combined_PROFUMO_noGSR.rds")
} else {
  file.path(dir_project, "priors", sprintf("GICA%d", nIC), paste0("prior_combined_", sprintf("GICA%d", nIC), "_noGSR.rds"))
}

############################## Start plotting #########################################################################################

for (subid in subject_ids){

  subject_engagements <- list()

  for (sesid in session_id) {

    # Get name

    cat("Subject; ", subid, " Session:", sesid, "\n")
    
    # Define base name for outputs
    base_name <- paste0("sub-", subid, "ses-", sesid, "_brainmap")
    
    # Define brain map output directory for the subject
    bm_dir <- file.path(output_dir, paste0("sub-", subid, "_ses-", sesid))
    
    if (scrubbing) {
      
      # check if scrubbing results already exist
      scrubbing_file <- file.path(bm_dir, paste0(base_name, "_scrubbing_results.rds"))
      }
    
    if (smoothing) {
      # add _smoothed-XXmm to the file names
      base_name <- paste0(base_name, "_smoothed-", smoothing, "mm")
    }

    # Read in RDS file  
  
    bMap = readRDS(file.path(bm_dir, paste0(base_name, ".rds")))
    
    # Generate engagement map ############## FIGURE FOCAL ENGAGEMENT MAP ##############

    z = c(1, 2, 3)
    eng <- engagements(
      bMap,
      z = z,
      method_p = "bonferroni"
    )
    
    eng = readRDS(file.path(bm_dir, paste0(base_name, "_engagements_bon_z-0123", ".rds")))
    fname = file.path(dir_data, "../manuscript/figures", paste0("posterior_engagement_Yeo17_", label_name, "_z-", z))
    plot(eng, idx = 14, stat = "engaged", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname) 


    # Save engagement map at Z>1 for comparison between sessions

    subject_engagements[[sesid]] <- engagements(bMap, z = 1, method_p = "bonferroni")
    
  }

  # Make comparison between sessions ############## FIGURE TEST-RESTEST RELIABILITY ######

  # open both sessions of the subject
  # make cifti file with both sessions 
  comparison_cifti = (subject_engagements[[session_id[2]]]$engaged * 2 + subject_engagements[[session_id[1]]]$engaged)
  # Medialwall is expected as -1
  comparison_cifti$data$cortex_left[comparison_cifti$data$cortex_left <= 0] = NA
  comparison_cifti$data$cortex_right[comparison_cifti$data$cortex_right <= 0] = NA
  
  fname = file.path(dir_data, "../manuscript/figures", paste0("sub-", subid, "_sessions-comparison_DefaultA.png"))
  
  plot(comparison_cifti, idx = 14, alpha = 1, color_mode = "qualitative", bg = "white", NA_color="white", fname=fname)

  # plot comparison
  fname = file.path(dir_data, "../manuscript/figures", paste0("posterior_engagement_Yeo17_", label_name, "_comparison.png"))
  #plot(comparison_cifti, idx = 14, stat = "engaged", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname)




}
