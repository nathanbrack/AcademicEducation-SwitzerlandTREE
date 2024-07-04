format_aic_bic = function(fit){
  aic = sapply(fit$analyses, AIC)
  bic = sapply(fit$analyses, BIC)
  info = data.frame(estimate = c(mean(aic), mean(bic)), std.error = c(sd(aic), sd(bic)), p.value = c(NA, NA))
  rownames(info) = c("Goodness-of-fit: AIC", "Goodness-of-fit: BIC")
  return(info)
}


format_significance_stars = function(x, p){
  nr_stars = (p < .05) + (p < .01) + (p < .001)
  nr_stars[is.na(nr_stars)] = 0
  stars = sapply(nr_stars, function(n)paste0(rep("*",n), collapse = ""))
  values = paste0(format(round(x,3), nsmall = 1), stars)
  return(values)
}