# Main script to run reproducibility GitHub repository 

# Set scriptdir as working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source("0_setup.R")

# Run framewise displacement filtering 
source("1_fd_time_filtering.R")

# Filter unrelated subjects
source("2_unrelated_filtering.R")

# Balance sex within age groups
source("3_balance_age_sex.R")

# Prepare Yeo17 parcellation for Prior estimation
source("4_parcellations.R")

######## Begin estimate priors over the parameter sweep defined in 0_setup.R ######
source("5_estimate_prior.R")

# Intialize performance summary
performance_tbl <- tibble()

for(encoding in encoding_sweep){
  for(nIC in nIC_sweep){
    for(GSR in GSR_sweep){
      
      # run while saving performance data
      timing <- system.time({
        estimate_and_export_prior(encoding,
                                  nIC,
                                  GSR,
                                  dir_data,
                                  TR_HCP)
      })
      
      performance_tbl <- add_row(
        performance_tbl,
        encoding = encoding,
        nIC = nIC,
        GSR = GSR,
        elapsed_sec = timing["elapsed"],
        user_sec = timing["user.self"],
        sys_sec = timing["sys.self"]
      )
    }
  }
}

# save RDS with performance tibble
saveRDS(performance_tbl, file.path(dir_data, "outputs", "prior_estimation_timings.rds"))

# End of priors estimation
####################################################################################