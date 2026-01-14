
# BRAIN MAP 

BOLD_paths1 <- file.path(dir_data, "inputs", "100206", "rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii")
BOLD_paths2 <- file.path(dir_data, "inputs", "100206", "rfMRI_REST1_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii")

# BOLD <- c(file.path(dir_data, "inputs", "100408", "rfMRI_REST2_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii"),
#                     file.path(dir_data, "inputs", "100408", "rfMRI_REST2_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii"))

BOLD <- c(BOLD_paths1, BOLD_paths2)

prior <- readRDS("~/Documents/GitHub/BayesianBrainMapping-Templates/priors/Yeo17/prior_combined_Yeo17_noGSR.rds")

TR_HCP <- .72
nT_HCP <- 1200
T_total <- floor(600 / TR_HCP)
T_scrub_start <- T_total + 1
scrub_BOLD1 <- replicate(length(BOLD_paths1), T_scrub_start:nT_HCP, simplify = FALSE)
scrub_BOLD2 <- replicate(length(BOLD_paths2), T_scrub_start:nT_HCP, simplify = FALSE)
scrub <- list(scrub_BOLD1, scrub_BOLD2)

bMap <- BrainMap(
  BOLD = BOLD,
  prior = prior,
  TR = 0.72,
  drop_first = 15,
  scrub=scrub,
#   brainstructures = c("left", "right"),
  )

# 100206, 100307, 100408
# REST1, REST2
saveRDS(bMap, file.path(dir_data, "outputs", "brain_map", "Yeo17", "figure", "100206", "brainMap_REST1_scrub.rds"))






# Smoothing the data (?)

BOLD_smooth <- gsub(".dtseries.nii$", "_smooth.dtseries.nii", BOLD)

for (i in seq_along(BOLD)) {
  smooth_cifti(
    x = BOLD[i],
    cifti_target_fname = BOLD_smooth[i]
  )
}

bMap <- BrainMap(
  BOLD = BOLD_smooth,
  prior = prior,
  TR = 0.72,
  drop_first = 15
)






# 100206, 100307, 100408
# REST1, REST2
saveRDS(bMap, file.path(dir_data, "outputs", "brain_map", "Yeo17", "figure", "100408", "brainMap_REST2.rds"))

# PLOT PRIOR MEAN

Q <- 17
bMap <- readRDS(file.path(dir_data, "outputs", "brain_map", "Yeo17", "figure", "100408", "brainMap_REST2.rds"))
label_name <- rownames(prior$template_parc_table)[prior$template_parc_table$Key == 14]
fname <- file.path(
  dir_data,
  "outputs", "brain_map", "Yeo17", "figure", "100408",
  paste0("posterior_Yeo17_REST2_", label_name)
)
plot(bMap, idx = 14, stat = "mean", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname, zlim=c(-0.3,0.3))

# ENGAGEMENT 

bMap <- readRDS(file.path(dir_data, "outputs", "brain_map", "Yeo17", "figure", "100408", "brainMap_REST2.rds"))

eng <- engagements(
   bMap = bMap,
   z=0,
   method_p="bonferroni"
   )

saveRDS(eng, file.path(dir_data, "outputs", "brain_map", "Yeo17", "figure", "100408", "engagements_REST2.rds"))

# PLOT ENGAGEMENT MAPS

eng <- readRDS(file.path(dir_data, "outputs", "brain_map", "Yeo17", "figure", "100408", "engagements_REST2.rds"))

fname <- file.path(
  dir_data,
  "outputs", "brain_map", "Yeo17", "figure", "100408",
  paste0("engagement_REST2_", label_name)
)

plot(eng, idx = 14, stat = "engaged", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname) 


# DICE OVERLAP 

