density_plot <- function(filename, data, x, color, bw){
  tiff(filename, res = 300, compression = "lzw", height = 7, width = 7, units = "in")
  p <- ggplot(data, aes(x=!!sym(x), color=!!sym(color))) + 
    geom_density(aes(linetype = !!sym(color)), bw = bw) +
    scale_color_manual(values = c("black", "black")) +
    scale_linetype_manual(values = c("dashed", "solid")) +
    theme_light()
  print(p)
  dev.off()
}