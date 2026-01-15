# Main script to run reproducibility GitHub repository 

# Set scriptdir as working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source("0_setup.R")

# Run framewise displacement filtering 
source("1_fd_time_filtering.R")

