profumo_dt <- file.path(dir_data, "inputs", "PROFUMO.dtseries.nii")
profumo_ds <- file.path(dir_data, "inputs", "PROFUMO.dscalar.nii")

convert_to_dscalar(
  profumo_dt,
  cifti_target_fname = profumo_ds
)

profumo_obj <- read_cifti(profumo_ds)

# Medial wall mask
mwall_path <- file.path(dir_data, "inputs", "Human.MedialWall_Conte69.32k_fs_LR.dlabel.nii")
mwall_cifti <- read_cifti(mwall_path)
mwall_L <- mwall_cifti$data$cortex_left == 0
mwall_R <- mwall_cifti$data$cortex_right == 0
profumo_obj$data$cortex_left[!mwall_L, ] <- NA
profumo_obj$data$cortex_right[!mwall_R, ] <- NA
profumo_mw <- move_to_mwall(profumo_obj, values = c(NA))

saveRDS(profumo_mw, file.path(dir_data, "outputs", "PROFUMO_simplified_mwall.rds"))

# Plot

plot(profumo_mw,zlim = c(-0.5, 2.5))

