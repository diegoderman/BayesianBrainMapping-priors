yeo_parc <- readRDS(file.path(dir_data, "outputs", "Yeo17_simplified_mwall.rds"))

labels_df <- yeo_parc$meta$cifti$labels$parcels
defaultA_key <- labels_df$Key[grepl("DefaultA", rownames(labels_df))]

yeo_vec <- c(yeo_parc$data$cortex_left, yeo_parc$data$cortex_right)

defaultA_map <- ifelse(yeo_vec == defaultA_key, 1, 0)

find_best_match_IC <- function(parc_file, default_map) {
  
  if (grepl("\\.rds$", parc_file)) {
    parc <- readRDS(parc_file)
  } else {
    parc <- read_cifti(parc_file, brainstructures = "all")
  }
  
  parc_matrix <- rbind(parc$data$cortex_left, parc$data$cortex_right)
  Q <- ncol(parc_matrix)
  
  cors <- sapply(1:Q, function(i) {
    ic_map <- parc_matrix[, i]
    cor(default_map, ic_map, use = "complete.obs")
  })
  
  best_idx <- which.max(abs(cors))
  list(best_ic = best_idx, max_cor = abs(cors[best_idx]))
}

GICA15_file <- file.path(dir_data, "inputs", "GICA15.dscalar.nii")
GICA25_file <- file.path(dir_data, "inputs", "GICA25.dscalar.nii")
GICA50_file <- file.path(dir_data, "inputs", "GICA50.dscalar.nii")
MSC_file <- file.path(dir_data, "outputs", "MSC_parcellation.rds")

match_gica15 <- find_best_match_IC(GICA15_file, defaultA_map)
cat("Best IC for GICA15:", match_gica15$best_ic, "cor =", match_gica15$max_cor, "\n")

match_gica25 <- find_best_match_IC(GICA25_file, defaultA_map)
cat("Best IC for GICA25:", match_gica25$best_ic, "cor =", match_gica25$max_cor, "\n")

match_gica50 <- find_best_match_IC(GICA50_file, defaultA_map)
cat("Best IC for GICA50:", match_gica50$best_ic, "cor =", match_gica50$max_cor, "\n")

match_msc <- find_best_match_IC(MSC_file, defaultA_map)
cat("Best IC for MSC:", match_msc$best_ic, "cor =", match_msc$max_cor, "\n")
