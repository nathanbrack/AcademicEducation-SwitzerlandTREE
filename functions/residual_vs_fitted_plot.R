residual_vs_fitted_plot <- function(filename, mids_object, n, m){
  fitted_all <- sapply(mids_object$analyses, fitted, type = "response") # lm ignores the type-argument, for glm it's necessary
  fitted_avg <- rowMeans(fitted_all)
  
  residuals_all <- sapply(mids_object$analyses, residuals, type = "response") # lm ignores the type-argument, for glm it's necessary
  residuals_avg <- rowMeans(residuals_all)
  
  tiff(filename, res = 300, compression = "lzw", height = 7, width = 7, units = "in")
  p <- binnedplot(fitted_avg, residuals_avg, xlab = "Expected Values", ylab = "Average residual", main = "Binned residual plot", cex.pts = 0.8, col.pts = 1, col.int = "gray")
  print(p)
  dev.off()
}