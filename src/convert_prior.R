
# convert old priors to new format

remove.packages("BayesBrainMap")
devtools::install_github("mandymejia/BayesBrainMap", "2.0")
library(BayesBrainMap)
dir_project <- "~/Documents/GitHub/BayesianBrainMapping-Templates"

convert_prior <- function(old_prior, nQ=NULL) {

  # Get and add `nQ`.
  nL <- ncol(old_prior$prior$mean)
  if (is.null(nQ)) { nQ <- nL }
  old_prior$params <- c(
    old_prior$params[seq(6)],
    list(nQ=nQ),
    old_prior$params[seq(7, length(old_prior$params))]
  )

  # Get IW est.
  FC_IW <- BayesBrainMap:::estimate_prior_FC_IW(
    old_prior$prior$FC$mean_empirical, old_prior$prior$FC$var_empirical, nL, nQ
  )

  # Check.
  stopifnot(all(FC_IW$nu == old_prior$prior$FC$nu))
  stopifnot(all(FC_IW$psi == old_prior$prior$FC$psi))

  # Make new FC component.
  old_Chol_etc <- old_prior$prior$FC_Chol[
    c("Chol_samp", "FC_samp_logdet", "FC_samp_cholinv", "FC_samp_maxeig",
      "Chol_svd", "pivots")]

  new_FC <- list(
    empirical = list(
      mean = old_prior$prior$FC$mean_empirical,
      var = old_prior$prior$FC$var_empirical
    ),
    IW = FC_IW,
    Chol = c(list(
      mean = old_prior$prior$FC_Chol$FC_samp_mean,
      var = old_prior$prior$FC_Chol$FC_samp_var
    ), old_Chol_etc)
  )

  old_prior$prior$FC_Chol <- NULL
  old_prior$prior$FC <- new_FC
  old_prior
}

prior_files <- list.files(file.path(dir_project, "priors", "Yeo17"), recursive = TRUE, full.names = TRUE)

for (file in prior_files) {
  prior <- readRDS(file)
  new_prior <- convert_prior(prior)
  
  base_name <- tools::file_path_sans_ext(basename(file))
  
  out_file <- file.path(dir_project, "converted_priors", paste0(base_name, ".rds"))
  saveRDS(new_prior, out_file)
}
