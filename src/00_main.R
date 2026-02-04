# Main script to run reproducibility demo in GitHub repository 

# Initialize libraries
Sys.setenv(R_LIBS_USER='$R_LIBS_USER')
# Set script directory
sourcedir = "~/Documents/GitHub/BayesianBrainMapping-priors/src"

# Setup up dependencies and parameters
source(file.path(sourcedir, "0_setup.R"))

# Run framewise displacement filtering 
source(file.path(sourcedir, "1_fd_time_filtering.R"))

# Filter unrelated subjects
source(file.path(sourcedir, "2_unrelated_filtering.R"))

# Balance sex within age groups
source(file.path(sourcedir, "3_balance_age_sex.R"))

# Prepare Yeo17 parcellation for Prior estimation
source(file.path(sourcedir, "4_parcellations.R"))

######## Begin estimate priors over the parameter sweep defined in 0_setup.R ######
source(file.path(sourcedir,"5_estimate_prior.R"))

# Intialize performance summary
performance_tbl <- tibble(
  encoding = character(),
  nIC = integer(),
  GSR = logical(),
  elapsed_sec = numeric(),
  user_sec = numeric(),
  sys_sec = numeric(),
  num_thr = numeric()
)

# Go over parameter sweep

for(encoding in encoding_sweep){
  for(nIC in nIC_sweep){
    for(GSR in GSR_sweep){
      
      # run while saving performance data
      timing <- system.time({
        estimate_and_export_prior(encoding,
                                  nIC,
                                  GSR,
                                  dir_data,
                                  TR_HCP,
                                  usePar = nThreads)
      })
      
      performance_tbl <- add_row(
        performance_tbl,
        encoding = encoding,
        nIC = nIC,
        GSR = GSR,
        elapsed_sec = timing["elapsed"],
        user_sec = timing["user.self"],
        sys_sec = timing["sys.self"],
        num_thr = nThreads
      )
    }
  }
}

# save RDS with performance tibble
saveRDS(performance_tbl, file.path(dir_data, "outputs", "prior_estimation_timings.rds"))

# End of priors estimation
####################################################################################

# Start individual fit_BBM

source(file.path(sourcedir,"11_brainMap.R"))
# Run BrainMap
bMap = run_brainmap_for_subject(bold, prior, scrubbing = TRUE, smoothing = FALSE, output_dir = output_dir)
