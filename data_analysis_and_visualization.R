########################################################
#
# TABLE OF CONTENTS:
#
# 1. Load and prepare data
# 2. Descriptive statistics and visualizations
#   2.1 Summary statistics and the correlation matrix
#   2.2 Density plots
# 3. Dealing with missing values (MICE-imputations)
# 4. Fit the models: LPM and GLM
#   4.1 First transition to academic education
#   4.2 Second transition to university
# 5. Make predictions and visualize the results
#   5.1 First transition to academic education
#   5.2 Second transition to university
# 6. R-Session information for reproducibility
#
# Note: the single chapters can be folded and unfolded
# for a better overview over the whole code.
#

# 1. Load and prepare data ----

library(foreign)

# Read in data
raw_data = read.spss("data/PISATREE_belonging.sav", use.value.label = T, to.data.frame = T, add.undeclared.levels = "no", max.value.labels = 3)
raw_data = raw_data[!is.na(raw_data$hightrack), ]

# Selection of the analytic sub-sample and the relevant variables
vars = c("t2acadedu","University_t4_9","outsider","belong","awkward","t2clis1","t2clis2","t2clis3","hisei","bthr","sex01","age_y","immig","wleread","parinvol")
sel = raw_data$hightrack == "high track / pre-gymnasial" # select high track students
data = raw_data[sel, vars]



# 2. Descriptive statistics and visualizations ----

## 2.1 Summary statistics and the correlation matrix ----

library(stargazer)
library(sjPlot)

# stargazer for the summary statistics of the data
stargazer(data, type = "html", out = "tables/table1_summary_statistics.doc")

# for the Pearson-style correlation matrix, convert factors to numerics
correlation_data = data
correlation_data$sex01 = as.numeric(correlation_data$sex01)-1
correlation_data$immig = as.numeric(correlation_data$immig)-1
correlation_data$t2acadedu = as.numeric(correlation_data$t2acadedu)-1
correlation_data$University_t4_9 = as.numeric(correlation_data$University_t4_9)-1
tab_corr(correlation_data, corr.method = "pearson", na.deletion = "pairwise", file = "tables/table2_correlation_matrix.doc")


## 2.2 Density plots ----

library(dplyr)
library(ggplot2)
source("functions/density_plots.R")

plot_data1 <- data %>% 
  rename(`upper-secondary level` = t2acadedu, `socio-economic status (SES)` = hisei, `future expectations` = bthr)

density_plot("figures/density_plots/density1_socioeconomic_status.tif", data = plot_data1 %>% filter(!is.na(`upper-secondary level`) & !is.na(`socio-economic status (SES)`)), x = "socio-economic status (SES)", color = "upper-secondary level", bw = 5)
density_plot("figures/density_plots/density1_future_expectations.tif", data = plot_data1 %>% filter(!is.na(`upper-secondary level`) & !is.na(`future expectations`)), x = "future expectations", color = "upper-secondary level", bw = 5)


plot_data2 <- data %>% 
  rename(`socio-economic status (SES)` = hisei, `future expectations` = bthr) %>% 
  mutate(`university attendance` = recode_factor(University_t4_9, `never enrolled at Univ./ETH` = "never enrolled",
                                                 `enrolled at least once at Univ./ETH between t4 and t9` = "enrolled at least once"))

density_plot("figures/density_plots/density2_socioeconomic_status.tif", data = plot_data2 %>% filter(!is.na(`university attendance`) & !is.na(`socio-economic status (SES)`)), x = "socio-economic status (SES)", color = "university attendance", bw = 5)
density_plot("figures/density_plots/density2_future_expectations.tif", data = plot_data2 %>% filter(!is.na(`university attendance`) & !is.na(`future expectations`)), x = "future expectations", color = "university attendance", bw = 5)



# 3. Dealing with missing values (MICE-imputations) ----

library(mice)

round(100 * colSums(is.na(data)) / nrow(data), 1) # proportion of missing values
m = 50 # number of imputations
set.seed(14) # for reproducibility
mice_data = mice(data, m = m, print = FALSE)
impList <- list()
for(i in 1:mice_data$m) impList[[i]] <- complete(mice_data, action = i)
# Note: here we save each of the m = 50 imputed data sets in a list of length 50
# for fitting the model, that is not necessary and we can use the mice-object "mice_data"
# however, for the plots of the results using ggpredict() we will need the list of the datasets



# 4. Fit the models: LPM and GLM ----

library(arm)


## 4.1 First transition to academic education ----

# fitting the different models

# the five hierarchical models: models 0, 1, 2, 3, 4
formula10 = as.numeric(t2acadedu)-1 ~ scale(hisei) + 
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 0 without psychological resources
formula11 = as.numeric(t2acadedu)-1 ~ scale(hisei) + scale(bthr) + I(scale((outsider+belong+awkward)/3)) + 
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 1 with only main effects
formula12 = as.numeric(t2acadedu)-1 ~ scale(hisei) * scale(bthr) + I(scale((outsider+belong+awkward)/3)) + 
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 2 with the significant two-way interaction
formula13 = as.numeric(t2acadedu)-1 ~ scale(hisei) * scale(bthr) + I(scale((outsider+belong+awkward)/3)) + 
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) + # model 3 with all two-way interactions
  scale(hisei):I(scale((outsider + belong + awkward)/3)) + scale(bthr):I(scale((outsider + belong + awkward)/3))
formula14 = as.numeric(t2acadedu)-1 ~ scale(hisei) * scale(bthr) * I(scale((outsider+belong+awkward)/3)) + 
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 4 with three-way interactions

# linear probability models
lpm10 = lm.mids(formula10, data = mice_data) # summary(pool(lpm10))
lpm11 = lm.mids(formula11, data = mice_data) # summary(pool(lpm11))
lpm12 = lm.mids(formula12, data = mice_data) # summary(pool(lpm12))
lpm13 = lm.mids(formula13, data = mice_data) # summary(pool(lpm13))
lpm14 = lm.mids(formula14, data = mice_data) # summary(pool(lpm14))

# logistic regression models
glm10 = glm.mids(formula10, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm10))
glm11 = glm.mids(formula11, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm11))
glm12 = glm.mids(formula12, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm12))
glm13 = glm.mids(formula13, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm13))
glm14 = glm.mids(formula14, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm14))


# make a table with the coefficients of all five models

source("functions/coefficients_table_model_comparison.R")

proper_names1 = c("(Intercept)"="Intercept","scale(hisei)"="Parental socioeconomic status (SES)","scale(bthr)"="Future expectations (FEX)",
                  "I(scale((outsider + belong + awkward)/3))"="Sense of belonging in lower-s. s. (SOB)","sex01male"="Male","scale(age_y)"="Age",
                  "immigfirst-generation immigrant (born abroad)"="First-generation immigrant","scale(wleread)"="Reading skills",
                  "scale(parinvol)"="Parental involvement","scale(hisei):scale(bthr)"="SES*FEX",
                  "scale(hisei):I(scale((outsider + belong + awkward)/3))"="SES*SOB","scale(bthr):I(scale((outsider + belong + awkward)/3))"="FEX*SOB",
                  "scale(hisei):scale(bthr):I(scale((outsider + belong + awkward)/3))"="SES*FEX*SOB")
coefficients_table(filename = "tables/table3_lpm.doc", model = "lpm1", proper_names = proper_names1)
coefficients_table(filename = "tables/table3_glm.doc", model = "glm1", proper_names = proper_names1)


# anova model comparisons (tests whether coefficients are significantly different)

source("functions/format_anova_results.R") # helper functions

lpm1hisei_bthr = lm.mids(as.numeric(t2acadedu)-1 ~ I(scale(hisei) + scale(bthr)) + I(scale((outsider+belong+awkward)/3)) +
                           sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol), data = mice_data)
anova1hisei_bthr = anova(lpm1hisei_bthr, lpm11)
paste("To academic education, difference between SES and FEX:", format_anova_results(anova1hisei_bthr))

lpm1hisei_sob = lm.mids(as.numeric(t2acadedu)-1 ~ scale(bthr) + I(scale(hisei) + scale((outsider+belong+awkward)/3)) +
                          sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol), data = mice_data)
anova1hisei_sob = anova(lpm1hisei_sob, lpm11)
paste("To academic education, difference between SES and SOB:", format_anova_results(anova1hisei_sob))



## 4.2 Second transition to university ----

# the five hierarchical models: models 0, 1, 2, 3, 4
formula20 = as.numeric(University_t4_9)-1 ~ t2acadedu + scale(hisei) +
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 0 without psychological resources
formula21 = as.numeric(University_t4_9)-1 ~ t2acadedu + scale(hisei) + scale(bthr) + I(scale((t2clis1+t2clis2+t2clis3)/3)) +
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 1 with only main effects
formula22 = as.numeric(University_t4_9)-1 ~ t2acadedu + scale(hisei) + scale(bthr) * I(scale((t2clis1+t2clis2+t2clis3)/3)) +
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 2 with the significant two-way interaction
formula23 = as.numeric(University_t4_9)-1 ~ t2acadedu + scale(hisei) * scale(bthr) + I(scale((t2clis1+t2clis2+t2clis3)/3)) +
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) + # model 3 with all two-way interactions
  scale(hisei):I(scale((t2clis1+t2clis2+t2clis3)/3)) + scale(bthr):I(scale((t2clis1+t2clis2+t2clis3)/3))
formula24 =as.numeric(University_t4_9)-1 ~ t2acadedu + scale(hisei) * scale(bthr) * I(scale((t2clis1+t2clis2+t2clis3)/3)) +
  sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol) # model 4 with three-way interactions

# linear probability models
lpm20 = lm.mids(formula20, data = mice_data) # summary(pool(lpm20))
lpm21 = lm.mids(formula21, data = mice_data) # summary(pool(lpm21))
lpm22 = lm.mids(formula22, data = mice_data) # summary(pool(lpm22))
lpm23 = lm.mids(formula23, data = mice_data) # summary(pool(lpm23))
lpm24 = lm.mids(formula24, data = mice_data) # summary(pool(lpm24))

# logistic regression models
glm20 = glm.mids(formula20, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm20))
glm21 = glm.mids(formula21, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm21))
glm22 = glm.mids(formula22, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm22))
glm23 = glm.mids(formula23, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm23))
glm24 = glm.mids(formula24, data = mice_data, family=binomial(link = "logit")) # summary(pool(glm24))


# make a table with the coefficients of all five models

proper_names2 = c("(Intercept)"="Intercept","t2acadeduacademic education"="Academic education","scale(hisei)"="Parental socioeconomic status (SES)",
                  "scale(bthr)"="Future expectations (FEX)","I(scale((t2clis1 + t2clis2 + t2clis3)/3))"="Sense of belonging in upper-s. s. (SOB)",
                  "sex01male"="Male","scale(age_y)"="Age","immigfirst-generation immigrant (born abroad)"="First-generation immigrant",
                  "scale(wleread)"="Reading skills","scale(parinvol)"="Parental involvement","scale(hisei):scale(bthr)"="SES*FEX",
                  "scale(hisei):I(scale((t2clis1 + t2clis2 + t2clis3)/3))"="SES*SOB","scale(bthr):I(scale((t2clis1 + t2clis2 + t2clis3)/3))"="FEX*SOB",
                  "scale(hisei):scale(bthr):I(scale((t2clis1 + t2clis2 + t2clis3)/3))"="SES*FEX*SOB")
coefficients_table(filename = "tables/table4_lpm.doc", model = "lpm2", proper_names = proper_names2)
coefficients_table(filename = "tables/table4_glm.doc", model = "glm2", proper_names = proper_names2)


# anova model comparisons (tests whether coefficients are significantly different)

lpm2bthr_sob = lm.mids(as.numeric(University_t4_9)-1 ~ t2acadedu + scale(hisei) + I(scale(bthr) + scale((t2clis1+t2clis2+t2clis3)/3)) +
                         sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol), data = mice_data)
anova2bthr_sob = anova(lpm2bthr_sob, lpm21)
paste("To university, difference between SOB and FEX:", format_anova_results(anova2bthr_sob))

lpm2interaction = lm.mids(as.numeric(University_t4_9)-1 ~ t2acadedu + scale(hisei) + scale(bthr) * I(scale((t2clis1+t2clis2+t2clis3)/3)) +
                            sex01 + scale(age_y) + immig + scale(wleread) + scale(parinvol), data = mice_data)
anova2interaction = anova(lpm21, lpm2interaction)
paste("To university, interaction between SOB and FEX:", format_anova_results(anova2interaction))



# 5. Make predictions and visualize the results ----

library(ggeffects)
library(ggplot2)

# create the needed levels for prediction: SES (hisei), sense of belonging (SOB), and future expectations (bthr)
SOB_levels = seq(1, 4, 1/3)
SOBt0_term = paste0("SOB_t0 [", paste(SOB_levels, collapse = ", "), "]")

hisei_avg_sd = c(mean(data$hisei, na.rm = T), sd(data$hisei, na.rm = T))
hisei_levels = c(hisei_avg_sd[1]-hisei_avg_sd[2], hisei_avg_sd[1], hisei_avg_sd[1]+hisei_avg_sd[2])
hisei_term = paste0("hisei [", paste(hisei_levels, collapse = ", "), "]")

bthr_avg_sd = c(mean(data$bthr, na.rm = T), sd(data$bthr, na.rm = T))
bthr_levels = c(bthr_avg_sd[1]-bthr_avg_sd[2], bthr_avg_sd[1], bthr_avg_sd[1]+bthr_avg_sd[2])
bthr_term = paste0("bthr [", paste(bthr_levels, collapse = ", "), "]")


## 5.1 First transition to academic education ----

source("functions/prediction_pooling_mice.R")

# predict and plots the probabilities for model 2 with the significant two-way interaction
pooled_pred_lpm12 = pooled_predictions(imp_list, terms = c(hisei_term, bthr_term), formula = formula12, model = "lpm")
plot_predictions(filename = "figures/figure1_lpm_model2_twoway.tif", pooled_pred_lpm12, line_legend = "Future\nexpectations",
                 xlabel = "Socioeconomic status of parents", ylabel = "Predicted probability of transitioning to academic education")

pooled_pred_glm12 = pooled_predictions(imp_list, terms = c(hisei_term, bthr_term), formula = formula12, model = "glm")
plot_predictions(filename = "figures/figure1_glm_model2_twoway.tif", pooled_pred_glm12, line_legend = "Future\nexpectations",
                 xlabel = "Socioeconomic status of parents", ylabel = "Predicted probability of transitioning to academic education")


## 5.2 Second transition to university ----

acadedu_term = "t2acadedu [academic education]"
SOBt2_term = paste0("SOB_t2 [", paste(SOB_levels, collapse = ", "), "]")

# predict and plots the probabilities for model 2 with the significant two-way interaction
pooled_pred_lpm22 = pooled_predictions(imp_list, terms = c(SOBt2_term, bthr_term, acadedu_term), formula = formula22, model = "lpm")
plot_predictions(filename = "figures/figure2_lpm_model2_twoway.tif", pooled_pred_lpm22, line_legend = "Future\nexpectations",
                 xlabel = "                      Sense of belonging in upper-secondary school", ylabel = "Predicted probability of transitioning to university")

pooled_pred_glm22 = pooled_predictions(imp_list, terms = c(SOBt2_term, bthr_term, acadedu_term), formula = formula22, model = "glm")
plot_predictions(filename = "figures/figure2_glm_model2_twoway.tif", pooled_pred_glm22, line_legend = "Future\nexpectations",
                 xlabel = "                      Sense of belonging in upper-secondary school", ylabel = "Predicted probability of transitioning to university")


# 6. R-Session information for reproducibility ----

session_info <- capture.output(sessionInfo())
writeLines(session_info, "R_session_info_for_reproducibility.txt")


