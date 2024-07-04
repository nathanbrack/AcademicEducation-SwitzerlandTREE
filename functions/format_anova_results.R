format_anova_results <- function(my_anova){
  statistics = my_anova$out$`2 ~~ 1`$result[,"F.value"]
  df = my_anova$out$`2 ~~ 1`$dfcom
  p = my_anova$out$`2 ~~ 1`$result[,"P(>F)"]
  clean_summary = sprintf("statistics = %.1f; df = %.0f; p-value = %.3f", statistics, df, p)
  return(clean_summary)
}