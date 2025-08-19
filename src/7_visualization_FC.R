
# Plots Functional Connectivity (FC) priors for each prior using both the Cholesky and Inverse-Wishart parameterization


remove.packages("fMRItools")
devtools::install_github("mandymejia/fMRItools", "7.0")
library(fMRItools)


remove.packages("BayesBrainMap")
devtools::install_github("mandymejia/BayesBrainMap", "2.0")
library(BayesBrainMap)

prior_files <- list.files(file.path(dir_project, "priors"), recursive = TRUE, full.names = TRUE)

get_prior_title <- function(base_name, encoding) {
  gsr <- if (grepl("noGSR", base_name)) "noGSR" else "GSR"

  if (grepl("Yeo17", base_name, ignore.case = TRUE)) {
    return(paste0("Yeo17 ", gsr))
  } else if (grepl("MSC", base_name, ignore.case = TRUE)) {
    return(paste0("MSC ", gsr))
  } else if (grepl("PROFUMO", base_name, ignore.case = TRUE)) {
    return(paste0("PROFUMO ", gsr))
  }

  ic_match <- regmatches(base_name, regexpr("GICA\\d+", base_name))
  nIC <- as.numeric(gsub("GICA", "", ic_match))

  paste0("GICA ", nIC, " ", gsr)
}

for (file in prior_files_combined) {
    cat("Processing prior:", file, "\n")
    prior <- readRDS(file)
    
    base_name <- tools::file_path_sans_ext(basename(file))

    cat("Processing prior:", base_name, "\n")

    # LABELS
    if (grepl("Yeo17", base_name, ignore.case = TRUE)) {
      labs <- rownames(prior$template_parc_table)[prior$template_parc_table$Key > 0]
    } else if (grepl("MSC", base_name, ignore.case = TRUE)) {
      # change FC dim
      prior$prior$FC_Chol$FC_samp_mean <- prior$prior$FC_Chol$FC_samp_mean[2:18, 2:18, drop=FALSE]
      prior$prior$FC_Chol$FC_samp_var  <- prior$prior$FC_Chol$FC_samp_var[2:18, 2:18, drop=FALSE]
      prior$prior$FC$mean_empirical <- prior$prior$FC$mean_empirical[2:18, 2:18, drop=FALSE]
      prior$prior$FC$var_empirical  <- prior$prior$FC$var_empirical[2:18, 2:18, drop=FALSE]
      labs <- rownames(prior$template_parc_table)[prior$template_parc_table$Key > 0]
    } else if (grepl("PROFUMO", base_name, ignore.case = TRUE)) {
      labs <- paste0("Network ", 1:12)
    } else {
      labs <- paste0("IC", 1:dim(prior$prior$mean)[2])
    }

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

    p1 <- plot(prior, what="FC", FC_method = "Chol", stat="mean", labs = labs,
        title = paste0(plot_title, " Cholesky FC Prior"))
    ggplot2::ggsave(file.path(out_dir, paste0(base_name, "_FC_Cholesky_mean.png")), plot = p1, bg = "white")

    p2 <-plot(prior, what="FC",  FC_method = "Chol", stat="sd", labs = labs, 
        title = paste0(plot_title, " Cholesky FC Prior"))
    ggplot2::ggsave(file.path(out_dir, paste0(base_name, "_FC_Cholesky_sd.png")), plot = p2, bg = "white") 

    # p3 <-plot(prior, what="FC",  FC_method = "IW", stat="mean", labs = labs, 
    #     title = paste0(plot_title, "Inverse-Wishart FC Prior Mean"))
    # ggplot2::ggsave(file.path(out_dir, paste0(base_name, "_FC_IW_mean.png")), plot = p3, bg = "white")

    # p4 <- plot(prior, what="FC",  FC_method = "IW", stat="sd", labs = labs, 
    #     title = paste0(plot_title, "Inverse-Wishart FC Prior SD"))
    # ggplot2::ggsave(file.path(out_dir, paste0(base_name, "_FC_IW_sd.png")), plot = p4, bg = "white")

    p5 <- plot(prior, what="FC", FC_method = "emp", stat="mean", labs = labs,
        title = paste0(plot_title, " Empirical FC Prior"))
    ggplot2::ggsave(file.path(out_dir, paste0(base_name, "_FC_Empirical_mean.png")), plot = p5, bg = "white")

    p6 <-plot(prior, what="FC",  FC_method = "emp", stat="sd", labs = labs, 
        title = paste0(plot_title, " Empirical FC Prior"))
    ggplot2::ggsave(file.path(out_dir, paste0(base_name, "_FC_Empirical_sd.png")), plot = p6, bg = "white") 

}
