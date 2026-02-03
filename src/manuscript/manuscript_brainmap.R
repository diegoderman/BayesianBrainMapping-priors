#' This is a version of "11_brainMap.R" adapted for the manuscript, 
#' it takes a subject and session from the HCP dataset and fits BBM using the selected prior.
#' 
#' HCP data is fetched directly from HCP directory. 
#' Outputs are saved in a separate directory for manuscript composition.
 
# source brainMap for function
source(file.path(sourcedir, "11_brainMap.R"))

# set output directory
manuscript_output_dir <- "~/Documents/GitHub/BayesianBrainMapping-priors/manuscript"
output_dir <- file.path(manuscript_output_dir, "outputs", "brain_map")
# create output directory if it does not exist
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# set subject and session
subject_ids <- c("100307", "100206") # example subject
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


# run brain mapping and save outputs
mclapply(subject_ids, mc.cores = 2, function(subject_id) {
    cat("Processing subject:", subject_id, "\n")

    for (sesid in session_id) {
        cat("  Session:", sesid, "\n")

        # Define BOLD file paths for the subject
        bold1 <- file.path(dir_HCP, subject_id, "MNINonLinear", "Results", paste0("rfMRI_", sesid, "_LR"), paste0("rfMRI_", sesid, "_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii"))
        bold2 <- file.path(dir_HCP, subject_id, "MNINonLinear", "Results", paste0("rfMRI_", sesid, "_RL"), paste0("rfMRI_", sesid, "_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii"))
        
        bold <- c(bold1, bold2)
        
        # Define base name for outputs
        base_name <- paste0("sub-", subject_id, "ses-", sesid, "_brainmap")
        
        # Define brain map output directory for the subject
        bm_dir <- file.path(output_dir, paste0("sub-", subject_id, "ses-", sesid))
        dir.create(bm_dir, recursive = TRUE, showWarnings = FALSE)

        # read cifti files
        bold_cifti <- lapply(bold, read_cifti)
        
        if (scrubbing) {

            # check if scrubbing results already exist
            scrubbing_file <- file.path(bm_dir, paste0(base_name, "_scrubbing_results.rds"))
            if (file.exists(scrubbing_file)) {
                cat("  Loading existing scrubbing results for subject", subject_id, "session", sesid, "\n")
                scrubbing_results <- readRDS(scrubbing_file)
                scrub = lapply(scrubbing_results, `[[`, "outlier_flag")
            } else {

                # Define scrubbing indices (example: scrubbing last 600 seconds)
                cat("Running scrubbing for bold timeseries...", "\n")
            
            
                # projection scrub
                scrubbing_results <- lapply(bold_cifti, scrub_xifti)
                scrub = lapply(scrubbing_results, `[[`, "outlier_flag")

                # save scrubbing results for this subject and session
                saveRDS(scrubbing_results, file.path(bm_dir, paste0(base_name, "_scrubbing_results.rds")))
            }
        }
        
        if (smoothing) {
          bold_cifti <- lapply(bold_cifti, function(x) {
                    smooth_cifti(x, surf_FWHM = smoothing, vol_FWHM = smoothing)
                    })
            # add _smoothed-XXmm to the file names
            base_name <- paste0(base_name, "_smoothed-", smoothing, "mm")
        }

        bMap <- fit_BBM(
            BOLD = bold_cifti,
            prior = prior_path,
            var_method = method_variance,
            TR = TR_HCP,
            drop_first = 5,
            GSR = FALSE,
            scrub = scrub,
            usePar = nThreads
        )

        saveRDS(bMap, file.path(bm_dir, paste0(base_name, ".rds")))

        # save engagements
        z = c(0, 1, 2, 3)
        eng <- id_engagements(
            bMap,
            z = z,
            method_p = "bonferroni"
        )
        saveRDS(eng, file.path(bm_dir, paste0(base_name, "_engagements_bon_z-0123", ".rds")))
        cat("Finished subject", subject_id, "session", sesid, "\n")
    }
})

