pooled_predictions <- function(imp_list, terms, formula, model){
  pred_list = lapply(impList, function(x){
    x$SOB_t0 = rowMeans(x[ , c("outsider","belong","awkward")])
    x$SOB_t2 = rowMeans(x[ , c("t2clis1","t2clis2","t2clis3")])
    
    formula_string = deparse1(formula, collapse = "")
    formula_SOBt0 = gsub("I(scale((outsider + belong + awkward)/3))", "SOB_t0", formula_string, fixed = TRUE)
    formula_SOBt2 = gsub("I(scale((t2clis1 + t2clis2 + t2clis3)/3))", "SOB_t2", formula_SOBt0, fixed = TRUE)
    formula_updated = as.formula(formula_SOBt2)
    
    if(model == "lpm"){
      fit = lm(formula_updated, data = x)
    }else if(model == "glm"){
      fit = glm(formula_updated, data = x, family=binomial(link = "logit")) 
    }else{
      stop("Model not lpm or glm!")
    }
    
    return(ggpredict(fit, terms = terms))
  })
  
  pooled_pred = pool_predictions(pred_list)
  return(pooled_pred)
}

plot_predictions <- function(filename, pooled_pred, line_legend, xlabel, ylabel){
  tiff(filename, res = 300, compression = "lzw", height = 7, width = 4, units = "in")
  p <- ggplot(pooled_pred, aes(x, predicted)) + geom_line(aes(linetype = group)) + ylim(0, 1) + theme_bw() +
    xlab(xlabel) + ylab(ylabel) +
    labs(title = "") + theme(legend.position = "right") +
    scale_linetype_manual(name = line_legend, values=1:3, labels = c("Mean - 1 SD", "Mean", "Mean + 1 SD")) +
    theme(text=element_text(size=11))
  print(p)
  dev.off()
}
