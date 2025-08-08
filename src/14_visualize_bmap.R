prior_file <- file.path(dir_project, "priors", "MSC", "prior_combined_MSC_GSR.rds")
prior <- readRDS(prior_file)
subjects <- paste0("sub-MSC", sprintf("%02d", 1))
Q <- dim(prior$prior$mean)[2]
label_names <- prior$template_parc_table$Name

for (subj in subjects) {
  for (i in 1:10) {
    session <- sprintf("ses-func%02d", i)

    bmap_file <- file.path(dir_data, "outputs", "brain_map", "MSC", subj, session, "subject_maps", paste0(subj, "_", session, "_bMap.rds"))
    eng_file  <- file.path(dir_data, "outputs", "brain_map", "MSC", subj, session, "engagements", paste0(subj, "_", session, "_engagements.rds"))

    bMap <- readRDS(bmap_file)
    eng  <- readRDS(eng_file)

    for (k in 1:Q) {

        cat("Visualizing", subj, session, k, "\n")

        label_name <- rownames(prior$template_parc_table)[prior$template_parc_table$Key == k-1]

        title_mean <- paste0("MSC Network ", label_name, " (#", k-1, ") - ", subj, " ", session, " Posterior Mean")
        fname_mean <- file.path(dir_data, "outputs", "brain_map", "MSC", subj, session, "subject_maps", paste0("posterior_MSC_", subj, "_", session, "_", label_name, "_mean"))
        plot(bMap, idx = k, title = title_mean, fname_suffix = "idx", fname = fname_mean)

        title_se <- paste0("MSC Network ", label_name, " (#", k-1, ") - ", subj, " ", session, " SE")
        fname_se <- file.path(dir_data, "outputs", "brain_map", "MSC", subj, session, "subject_maps", paste0("posterior_MSC_", subj, "_", session, "_", label_name, "_se"))
        plot(bMap, idx = k, title = title_se, fname_suffix = "idx", fname = fname_se)

        title_eng <- paste0("MSC Network ", label_name, " (#", k-1, ") - ", subj, " ", session, " Engagement")
        fname_eng <- file.path(dir_data, "outputs", "brain_map", "MSC", subj, session, "engagements", paste0("subject_MSC_", subj, "_", session, "_", label_name, "_eng"))
        plot(eng, idx = k, stat = "engaged", title = title_eng, fname_suffix = "idx", fname = fname_eng)
    }
  }
}
