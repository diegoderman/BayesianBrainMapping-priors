run_brainmap_for_subject <- function(prior_path, subject) {
  base_dir   <- "/N/project/clubneuro/MSC/washu_preproc/surface_pipeline"
  output_dir <- "/N/u/ndasilv/Quartz/Documents/GitHub/BayesianBrainMapping-Templates/data_OSF/outputs/brain_map/MSC"

  for (i in 1:10) {
    session <- sprintf("ses-func%02d", i)
    bm_dir <- file.path(output_dir, subject, session)
    dir.create(bm_dir, recursive = TRUE, showWarnings = FALSE)

    bold_file <- file.path(
      base_dir, subject, "processed_restingstate_timecourses", session, "cifti",
      paste0(subject, "_", session, "_task-rest_bold_32k_fsLR.dtseries.nii")
    )

    cat("Running BrainMap for", subject, session, "\n")

    bMap <- BrainMap(
      BOLD = bold_file,
      prior = prior_path,
      TR = 2.2,
      drop_first = 15,
      hpf = 0,
      GSR = FALSE
    )

    saveRDS(bMap, file.path(bm_dir, paste0(subject, "_", session, "_bMap.rds")))
  }

  cat("Finished subject", subject, "with prior", basename(prior_path), "\n")
}
