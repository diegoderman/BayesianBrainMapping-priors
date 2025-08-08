# Plots Functional Connectivity (FC) priors for each prior using both the Cholesky and Inverse-Wishart parameterization
remove.packages("BayesBrainMap")

devtools::install_github("mandymejia/BayesBrainMap", "2.0")
library(BayesBrainMap)

prior_files <- list.files(file.path(dir_project, "priors"), recursive = TRUE, full.names = TRUE)

get_prior_title <- function(base_name, encoding) {
  gsr <- if (grepl("noGSR", base_name)) "noGSR" else "GSR"

  if (grepl("Yeo17", base_name, ignore.case = TRUE)) {
    return(paste0("Yeo17 Prior - ", gsr, " (", encoding, ")"))
  }

  ic_match <- regmatches(base_name, regexpr("GICA\\d+", base_name))
  nIC <- as.numeric(gsub("GICA", "", ic_match))

  paste0("GICA ", nIC, " - ", gsr, " (", encoding, ")")
}

for (file in prior_files) {
    cat("Processing prior:", file, "\n")
    prior <- readRDS(file)
    
    base_name <- tools::file_path_sans_ext(basename(file))

    cat("Processing prior:", base_name, "\n")

    parts <- strsplit(base_name, "_")[[1]]
    encoding <- parts[2]      
    parcellation <- parts[3]   
    gsr_status <- parts[4]  

    out_dir <- file.path(dir_data, "outputs", "priors_plots", parcellation, encoding, gsr_status, "FC")
    cat("out_dir:", out_dir, "\n")
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

    # Number of ICs
    Q <- dim(prior$prior$mean)[2]
    plot_title <- get_prior_title(base_name, encoding)
        
    # FC Cholesky
    zlim_FC_mean <- c(-0.8, 0.8)
    zlim_FC_sd <- c(0, 0.4)

    plot(prior, maps = FALSE, FC = "Chol", stat="mean", FC_labs = paste0("IC", 1:15), 
        title = paste0(plot_title, "\nCholesky FC Prior Mean"), fname = file.path(out_dir, paste0(base_name, "_FC_Cholesky_mean.png")))
    plot(prior, maps = FALSE, FC = "Chol", stat="sd", FC_labs = paste0("IC", 1:15), 
        title = paste0(plot_title, "\nCholesky FC Prior SD"), fname = file.path(out_dir, paste0(base_name, "_FC_Cholesky_sd.png")))
    plot(prior, maps = FALSE, FC = "IW", stat="mean", FC_labs = paste0("IC", 1:15), 
        title = paste0(plot_title, "\nInverse-Wishart FC Prior Mean"), fname = file.path(out_dir, paste0(base_name, "_FC_IW_mean.png")))
    plot(prior, maps = FALSE, FC = "IW", stat="sd", FC_labs = paste0("IC", 1:15), 
        title = paste0(plot_title, "\nInverse-Wishart FC Prior SD"), fname = file.path(out_dir, paste0(base_name, "_FC_IW_sd.png")))
}
