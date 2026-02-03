# bMap
Q <- 17
#bMap <- readRDS(file.path(dir_data, "outputs", "brain_map", "Yeo17", "four_sessions", "brainMap_4sessions.rds"))
bMap <- readRDS(file.path(dir_data, "outputs", "brain_map", "Yeo17", "BOLD_single-subject_bMap.rds"))


label_name <- rownames(prior$template_parc_table)[prior$template_parc_table$Key == 14]
fname <- file.path(dir_data, "../figure_export/Figure5", paste0("posterior_Yeo17_", label_name))
dir.create(file.path(dir_data, "../figure_export/Figure5"), recursive = TRUE)
# plot(bMap, idx = 14, stat = "mean", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname, zlim=c(-round(3/Q, 3), round(3/Q, 3)))
# plot(bMap, idx = 14, stat = "se", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname,zlim=c(0, round(2/Q, 3)))


plot(bMap, idx = 14, stat = "mean", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname, zlim=c(-0.3,0.3))
plot(bMap, idx = 14, stat = "se", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname, zlim=c(0.03, 0.032))


files_written <- plot(bMap, idx = 14, stat = "se", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname, legend_fname = file.path("~/Desktop/Figure5/GICA_legend.png"), zlim=c(0, 0.040))

map_png    <- files_written[1]  
legend_png <- files_written[2] 

ciftiTools::view_comp(
    img    = map_png,
    title=NULL,
    legend = legend_png,
    legend_height = 0.4,
    fname  = file.path("~/Desktop", "Figure5", "Yeo17_bMap_Default_mean.png")
)

fname <- file.path("~/Desktop/Figure5", paste0("posterior_Yeo17_", label_name))
files_written <- plot(bMap, idx = 14, stat = "se", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname, legend_fname = file.path("~/Desktop/Figure5/GICA_legend.png"),zlim=c(0, round(2/Q, 3)))
 

map_png    <- files_written[1]  
legend_png <- files_written[2] 

ciftiTools::view_comp(
    img    = map_png,
    title=NULL,
    legend = legend_png,
    legend_height = 0.4,
    fname  = file.path("~/Desktop", "Figure5", "Yeo17_bMap_Default_se.png")
)

bMap <- readRDS(file.path(dir_data, "outputs", "brain_map", "Yeo17", "four_sessions", "brainMap_4sessions.rds"))

for (z in c(0, 1, 2, 3)){
eng <- readRDS(file.path(dir_data, "outputs", "brain_map", "Yeo17", paste0("BOLD_engagements_bon_z-", z, ".rds")))
fname = file.path(dir_data, "../figure_export/Figure5", paste0("posterior_engagement_Yeo17_", label_name, "_z-", z))
plot(eng, idx = 14, stat = "engaged", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname) 
}

# files_written <- plot(eng, idx = 14, stat = "engaged", title = "", cex.title = 1e-6, legend_embed = FALSE, fname=fname, legend_fname = file.path("~/Desktop/Figure5/GICA_legend.png"), zlim=c(-0.2, 0.2)) 

# map_png    <- files_written[1]  
# legend_png <- files_written[2] 

# ciftiTools::view_comp(
#     img    = map_png,
#     title=NULL,
#     legend = legend_png,
#     legend_height = 0.5,
#     fname  = file.path("~/Desktop", "Figure5", "Yeo17_bMap_Default_eng.png")
# )







