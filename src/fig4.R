# Template
GICA <- read_cifti(file.path(dir_data, "inputs", sprintf("GICA%d.dscalar.nii", 50)))
out_dir <- "~/Desktop"

files_written <- plot(
    GICA,
    idx   = 50,
    title = "",
    cex.title = 1e-6,
    legend_embed = FALSE,                                 
    fname = file.path(out_dir, "GICA15"),      
    legend_fname = file.path(out_dir, "GICA_legend.png")
)

map_png    <- files_written$surface[1]  
legend_png <- files_written$surface[2] 

ciftiTools::view_comp(
    img    = map_png,title=NULL,
    legend = legend_png,
    legend_height = 0.35,
    legend_side   = "right",
    fname  = file.path(out_dir, "Figure4", "GICA50_IC50.png")
)


# PRIOR (mean and sd)
file <- "/Users/nohelia/Documents/GitHub/BayesianBrainMapping-Templates/priors/GICA15/prior_combined_GICA15_noGSR.rds"
prior <- readRDS(file)

files_written <- plot(
    prior,
    stat = "mean",
    idx   = 15,
    title = "",cex.title = 1e-6,
    legend_embed = FALSE,                                 
    fname = file.path(out_dir, "GICA15"),      
    legend_fname = file.path(out_dir, "GICA_legend.png")
)

map_png    <- files_written$surface[1]  
legend_png <- files_written$surface[2] 

ciftiTools::view_comp(
    img    = map_png,title=NULL,
    legend = legend_png,
    legend_height = 0.35,
    fname  = file.path(out_dir, "Figure4", "prior_GICA15_IC15_mean.png")
)






