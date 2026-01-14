#latest
# remove.packages("fMRItools")
# devtools::install_github("mandymejia/fMRItools", "7.0")
# library(fMRItools)


remove.packages("BayesBrainMap")
devtools::install_github("mandymejia/BayesBrainMap", "2.0")
library(BayesBrainMap)

# library(ggplot2)
# library(scales)

jet_diverging <- function(...) {
  scale_fill_gradientn(
    colours = c("cyan", "green", "purple", "blue", "black", "red", "orange", "yellow"),
    values  = rescale(c(-0.5, -0.45, -0.3, -0.15, 0, 0.2, 0.3, 0.5)), 
    limits  = c(-0.5, 0.5),
    oob     = squish
  )
}

# SPATIAL OVERLAP MATRICES - YEO 17

# PARCELLATION
parcellation <- readRDS(file.path(dir_data, "outputs", "Yeo17_simplified_mwall.rds"))

v <- c(
  parcellation$data$cortex_left,
  parcellation$data$cortex_right
)

parcel_ids  <- 1:17

one_hot <- matrix(0, nrow = length(v), ncol = length(parcel_ids))

for (i in seq_along(parcel_ids)) {
  one_hot[, i] <- as.integer(v == parcel_ids[i])
}

mat <- cor(one_hot)


labs <- rownames(parcellation$meta$cifti$labels$parcels)[parcellation$meta$cifti$labels$parcels$Key > 0]
# p <- plot_FC_gg(mat, title= "", labs=labs)

p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title="",
) +
  theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"), # relative way
    legend.key.width  = unit(0.6, "cm")
  )

ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "Yeo17_parcellation_overlap.png"), plot = p, bg = "white") 

# PRIOR
prior <- readRDS(file.path(dir_project, "priors", "Yeo17", "prior_combined_Yeo17_GSR.rds"))

mat <- cor(prior$prior$mean)

parcel_names <- rownames(prior$template_parc_table)[prior$template_parc_table$Key > 0]
# p <- plot_FC_gg(mat, title= "", labs=parcel_names)
p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title=""
) +
  theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"),
    legend.key.width  = unit(0.6, "cm")
  )
ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "Yeo17_prior_overlap.png"), plot = p, bg = "white") 


# SPATIAL OVERLAP MATRICES - MSC

# PARCELLATION
parcellation <- readRDS(file.path(dir_data, "outputs", "MSC_parcellation.rds"))

v <- c(
  parcellation$data$cortex_left,
  parcellation$data$cortex_right
)

parcel_ids  <- 1:17

one_hot <- matrix(0, nrow = length(v), ncol = length(parcel_ids))

for (i in seq_along(parcel_ids)) {
  one_hot[, i] <- as.integer(v == parcel_ids[i])
}

mat <- cor(one_hot)

tab  <- parcellation$meta$cifti$labels$`Column number`
labs <- rownames(tab)[tab$Key > 0]
# p <- plot_FC_gg(mat, title= "", labs=labs)
p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title=""
) +
  theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"),
    legend.key.width  = unit(0.6, "cm")
  )
ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "MSC_parcellation_overlap.png"), plot = p, bg = "white") 

# PRIOR
prior <- readRDS(file.path(dir_project, "priors", "MSC", "prior_combined_MSC_GSR.rds"))
mat <- cor(prior$prior$mean)
mat <- mat[2:18, 2:18]
labs <- rownames(prior$template_parc_table)[prior$template_parc_table$Key > 0]
# p <- plot_FC_gg(mat, title= "", labs=labs)
p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title=""
) + theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"),
    legend.key.width  = unit(0.6, "cm")
  )
ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "MSC_prior_overlap.png"), plot = p, bg = "white") 


# SPATIAL OVERLAP MATRICES - GICA15

# PARCELLATION
parcellation <- read_cifti(file.path(dir_data, "inputs", "GICA15.dscalar.nii"))

v <- rbind(
  parcellation$data$cortex_left,
  parcellation$data$cortex_right
)           

# Return index of the maximum value in each row
labels <- max.col(abs(scale(v)), ties.method = "first")

one_hot <- matrix(0, nrow = nrow(v), ncol = ncol(v))
for (i in seq_along(labels)) {
  one_hot[i, labels[i]] <- 1
}

mat <- cor(one_hot)

labs <- paste0("IC", 1:15)
# p <- plot_FC_gg(mat, title= "", labs=labs)
p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title=""
) + theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"),
    legend.key.width  = unit(0.6, "cm")
  )
ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "GICA15_parcellation_overlap.png"), plot = p, bg = "white")


# PRIOR
prior <- readRDS(file.path(dir_project, "priors", "GICA15", "prior_combined_GICA15_GSR.rds"))
mat <- cor(prior$prior$mean)
labs <- paste0("IC", 1:15)
# p <- plot_FC_gg(mat, title= "", labs=labs)
p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title=""
) + theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"),
    legend.key.width  = unit(0.6, "cm")
  )
ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "GICA15_prior_overlap.png"), plot = p, bg = "white") 


# SPATIAL OVERLAP MATRICES - PROFUMO

# PARCELLATION
parcellation <- readRDS(file.path(dir_data, "outputs", "PROFUMO_simplified_mwall.rds"))

v <- rbind(
  parcellation$data$cortex_left,
  parcellation$data$cortex_right
)           

# Return index of the maximum value in each row
labels <- max.col(abs(scale(v)), ties.method = "first")

one_hot <- matrix(0, nrow = nrow(v), ncol = ncol(v))
for (i in seq_along(labels)) {
  one_hot[i, labels[i]] <- 1
}

mat <- cor(one_hot)

tab  <- parcellation$meta$cifti$labels$`Column number`
labs <- paste0("Network ", 1:12)
# p <- plot_FC_gg(mat, title= "", labs=labs)
p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title=""
) + theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"),
    legend.key.width  = unit(0.6, "cm")
  )
ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "PROFUMO_parcellation_overlap.png"), plot = p, bg = "white")

# PRIOR
prior <- readRDS(file.path(dir_project, "priors", "PROFUMO", "prior_combined_PROFUMO_GSR.rds"))
mat <- cor(prior$prior$mean)
labs <- paste0("Network ", 1:ncol(prior$prior$mean))
# p <- plot_FC_gg(mat, title= "", labs=labs)
p <- plot_FC_gg(
  mat,
  colFUN    = jet_diverging,
  labs      = labs,
  lim       = 0.5,
  title=""
) + theme(
    legend.title = element_blank(),
    legend.text  = element_text(size = 14),
    legend.key.height = unit(2, "cm"),
    legend.key.width  = unit(0.6, "cm")
  )
ggplot2::ggsave(file.path(dir_data, "outputs", "overlap_matrices", "PROFUMO_prior_overlap.png"), plot = p, bg = "white") 
