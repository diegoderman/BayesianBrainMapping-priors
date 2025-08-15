
library(reshape2)
library(ggplot2)

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

cor <- cor(one_hot)

parcel_names <- rownames(parcellation$meta$cifti$labels$parcels)[parcellation$meta$cifti$labels$parcels$Key > 0]
rownames(cor) <- parcel_names
colnames(cor) <- parcel_names

cor_melt <- reshape2::melt(cor)

custom_colors <- colorRampPalette(c("blue", "black", "red", "yellow"))(200)

p_parc <- ggplot(cor_melt, aes(x = factor(Var1, levels = rev(unique(Var1))), 
                     y = Var2, 
                     fill = value)) +
  geom_tile() +
  scale_fill_gradientn(
    colours = custom_colors,
    limits = c(-0.5, 0.5),
    oob = scales::squish,
    name = NULL
  ) +
  theme_minimal() +
  theme(
    axis.text.x.top = element_text(angle = 45, hjust = 0, size = 8),
    axis.text.y = element_text(size = 8),
    axis.title = element_blank(),
    panel.grid = element_blank()
  ) +
  scale_x_discrete(position = "top") +
  coord_fixed()

ggsave(file.path(dir_data, "outputs", "overlap_matrices", "Yeo17_parcellation_overlap.png"), plot = p_parc, width = 6, height = 6, dpi = 300, bg = "white")

# PRIOR
prior <- readRDS(file.path(dir_project, "priors", "Yeo17", "prior_combined_Yeo17_GSR.rds"))

cor <- cor(prior$prior$mean)

parcel_names <- rownames(prior$template_parc_table)[prior$template_parc_table$Key > 0]
rownames(cor) <- parcel_names
colnames(cor) <- parcel_names

cor_melt <- reshape2::melt(cor)

custom_colors <- colorRampPalette(c("blue", "black", "red", "yellow"))(200)

p_parc <- ggplot(cor_melt, aes(x = factor(Var1, levels = rev(unique(Var1))), 
                     y = Var2, 
                     fill = value)) +
  geom_tile() +
  scale_fill_gradientn(
    colours = custom_colors,
    limits = c(-0.2, 0.2),
    oob = scales::squish,
    name = NULL
  ) +
  theme_minimal() +
  theme(
    axis.text.x.top = element_text(angle = 45, hjust = 0, size = 8),
    axis.text.y = element_text(size = 8),
    axis.title = element_blank(),
    panel.grid = element_blank()
  ) +
  scale_x_discrete(position = "top") +
  coord_fixed()

ggsave(file.path(dir_data, "outputs", "overlap_matrices", "Yeo17_prior_overlap.png"), plot = p_parc, width = 6, height = 6, dpi = 300, bg = "white")







# SPATIAL OVERLAP MATRICES - MSC

# PARCELLATION
parcellation <- readRDS(file.path(dir_data, "outputs", "MSC_parcellation.rds"))

v <- c(
  parcellation$data$cortex_left,
  parcellation$data$cortex_right
)

# parcel_ids  <- 1:17

one_hot <- matrix(0, nrow = length(v), ncol = length(parcel_ids))

for (i in seq_along(parcel_ids)) {
  one_hot[, i] <- as.integer(v == parcel_ids[i])
}

cor <- cor(one_hot)

parcel_names <- rownames(parcellation$meta$cifti$labels$parcels)[parcellation$meta$cifti$labels$parcels$Key > 0]
rownames(cor) <- parcel_names
colnames(cor) <- parcel_names

cor_melt <- reshape2::melt(cor)

custom_colors <- colorRampPalette(c("blue", "black", "red", "yellow"))(200)

p_parc <- ggplot(cor_melt, aes(x = factor(Var1, levels = rev(unique(Var1))), 
                     y = Var2, 
                     fill = value)) +
  geom_tile() +
  scale_fill_gradientn(
    colours = custom_colors,
    limits = c(-0.5, 0.5),
    oob = scales::squish,
    name = NULL
  ) +
  theme_minimal() +
  theme(
    axis.text.x.top = element_text(angle = 45, hjust = 0, size = 8),
    axis.text.y = element_text(size = 8),
    axis.title = element_blank(),
    panel.grid = element_blank()
  ) +
  scale_x_discrete(position = "top") +
  coord_fixed()

ggsave(file.path(dir_data, "outputs", "overlap_matrices", "MSC_parcellation_overlap.png"), plot = p_parc, width = 6, height = 6, dpi = 300, bg = "white")
