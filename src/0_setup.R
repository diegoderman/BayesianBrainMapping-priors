# Setup

# install.packages("devtools")
# install.packages("gsignal")
# install.packages("ggcorrplot")

# install.packages("ciftiTools")            
# devtools::install_github("mandymejia/fMRIscrub", "14.0")          
# install.packages("fMRItools")          
# install.packages("viridis")
# install.packages("BayesBrainMap")

# Load packages
library(ggcorrplot)      # version 0.1.4.1
library(gsignal)         # version 0.3.7
library(ciftiTools)      # version 0.17.4
library(fMRIscrub)       # version 0.14.7
library(fMRItools)       # version 0.5.3
library(viridis)         # version 0.6.5
library(BayesBrainMap)   # version: 0.1.1 

# Set CIFTI Workbench path
wb_path <- "~/Downloads/workbench"
ciftiTools.setOption("wb_path", wb_path) 

# Set up paths
dir_HCP <- "/N/project/hcp_dcwan" # Location of HCP data
dir_project <- "~/Documents/GitHub/BayesianBrainMapping-Templates" # Path to GitHub folder

dir_data <- file.path(dir_project, "data_OSF") # Path to data folder

HCP_unrestricted_fname <- file.path(dir_data, "inputs", "unrestricted_HCP_demographics.csv")
HCP_restricted_fname <- file.path(dir_data, "inputs", "restricted_HCP.csv")

# Read CSV
HCP_unrestricted <- read.csv(HCP_unrestricted_fname)

# All subject IDS
subject_ids <- HCP_unrestricted$Subject

subject_ids_msc <- c(
  "sub-MSC01",
  "sub-MSC02",
  "sub-MSC03",
  "sub-MSC04",
  "sub-MSC05",
  "sub-MSC06",
  "sub-MSC07",
  "sub-MSC08",
  "sub-MSC09",
  "sub-MSC10"
)

sessions_msc <- c(
  "ses-func01", "ses-func02", "ses-func03", "ses-func04", "ses-func05",
  "ses-func06", "ses-func07", "ses-func08", "ses-func09", "ses-func10"
)

# Constants
fd_lag_HCP <- 4 
fd_cutoff <- .5 # Motion scrubbing threshold
TR_HCP <- .72 # Repetition time 
TR_MSC <- 2.2 # Repetition time for MSC data
nT_HCP <- 1200 # Timepoints for each resting state scan
nT_MSC <- 818 
min_total_sec <- 600 # Minimum duration of time series after scrubbing (600 sec = 10 min)


