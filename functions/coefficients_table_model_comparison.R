source("functions/format_model_results.R") # helper functions

coefficients_table <- function(filename, model, proper_names){
  summary_list = list()
  summary_combined = data.frame()
  for(i in 0:4){
    my_model = get(paste0(model, i))
    my_summary = summary(pool(my_model))
    rownames(my_summary) = proper_names[as.character(my_summary$term)]
    my_summary = rbind(my_summary[, c("estimate","std.error","p.value")], format_aic_bic(my_model))
    summary_list[[i+1]] = my_summary
    
    my_summary$estimate = format_significance_stars(my_summary$estimate, my_summary$p.value)
    my_summary$p.value = NULL
    colnames(my_summary) = paste0(c("estimate","std.error"), "_m", i)
    summary_combined = merge(summary_combined, my_summary, by=0, all=TRUE, sort = F)
    row.names(summary_combined) = summary_combined$Row.names
    summary_combined$Row.names = NULL
  }
  summary_list[[6]] = summary_combined[c(proper_names,"Goodness-of-fit: AIC","Goodness-of-fit: BIC"),]
  tab_dfs(summary_list, file = filename, digits = 3, show.rownames = TRUE, titles = c("model 0 without psychological resources",
                                                                                      "model 1 with only main effects",
                                                                                      "model 2 with the significant two-way interaction",
                                                                                      "model 3 with all two-way interactions",
                                                                                      "model 4 with three-way interactions",
                                                                                      "all five models combined (plz adjust to see the whole table: wide format/smaller fonts)"))
}
