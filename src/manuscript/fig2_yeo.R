out_dir <- "~/Documents/GitHub/BayesianBrainMapping-priors/figure_export"

# YEO17
prior_file <- "~/Documents/GitHub/BayesianBrainMapping-priors/priors/Yeo17/prior_combined_Yeo17_noGSR.rds"
prior <- readRDS(prior_file)

indices = c(11, 14, 5, 3, 17, 1)

# Ignore medial wall 
prior$template_parc_table <- subset(prior$template_parc_table, prior$template_parc_table$Key > 0)

# plot(
#   prior,
#   what = "maps",
#   stat  = "mean",
#   idx   = indices,
#   title = "",
#   cex.title = 1e-6,
#   legend_embed = FALSE,   
#   fname = file.path(out_dir, "Figure2_Yeo", "Yeo17.png"),
# )

for (idx in indices){
  network_name = rownames(prior$template_parc_table[prior$template_parc_table$Key == idx,])
  plot(
    prior,
    what="maps",
    stat="mean",
    idx = idx,
    title = paste0("Yeo 17 Network ", network_name),
    fname = file.path(out_dir, "Figure2_Yeo", paste0("Yeo17_", network_name, ".png"))
  )
  
}
