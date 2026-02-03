run_brainmap_for_subject <- function(subject, session) {
# run_brainmap_for_subject <- function(prior_path, subject) {
    prior_path <- file.path(dir_project, "priors", "MSC", "prior_combined_MSC_GSR.rds")
    base_dir   <- "/N/project/clubneuro/MSC/washu_preproc/surface_pipeline"
    output_dir <- "~/Documents/GitHub/BayesianBrainMapping-Templates/data_OSF/outputs/brain_map/MSC"

    bm_dir <- file.path(output_dir, subject, session)
    dir.create(bm_dir, recursive = TRUE, showWarnings = FALSE)

    bold_file <- file.path(
      base_dir, subject, "processed_restingstate_timecourses", session, "cifti",
      paste0(subject, "_", session, "_task-rest_bold_32k_fsLR.dtseries.nii")
    )

    cat("Running engagements for", subject, session, "\n")

    bMap <- fit_BBM(
      BOLD = bold_file,
      prior = prior_path,
      TR = 2.2,
      drop_first = 15,
      hpf = 0,
      GSR = FALSE
    )

    saveRDS(bMap, file.path(bm_dir, paste0(subject, "_", session, "_bMap.rds")))

    eng <- id_engagements(
      bMap,
      z = 5,
      method_p = "bonferroni"
    )

    saveRDS(eng, file.path(bm_dir, paste0(subject, "_", session, "_engagements_bon_z5.rds")))

  cat("Finished subject", subject, "session", session, "\n")
}


run_brainmap_for_subject("sub-MSC02", "ses-func10")

run_brainmap_for_subject("sub-MSC04", "ses-func10")

run_brainmap_for_subject("sub-MSC05", "ses-func10")

run_brainmap_for_subject("sub-MSC06", "ses-func10")

run_brainmap_for_subject("sub-MSC07", "ses-func10")

run_brainmap_for_subject("sub-MSC10", "ses-func10")