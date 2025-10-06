
# Wording of survey options confusing: who “reported they already have planned around work and family life” 
# Subset the respondents in the two groups – “how you would like to” versus “how you would have liked to” to check for differences wfaNow wfa3Now

## Original 4 categories
m1_wfaNow <- multinom(ideal ~ female + married + parent + wfaNow + essentialism_N, data, weights = weight)

## 6 categories at same time
m2_wfaNow <- multinom(ideal6 ~ female + married + parent + wfaNow + essentialism_N, data, weights = weight)


tidy(m1_wfaNow)
tidy(m2_wfaNow)

pp1_wfaNow       <- avg_predictions(m1_wfaNow, by = c("wfaNow"))

pp1_wfaNow %>%
  ggplot(aes(y = estimate, x = group, fill = wfaNow, ymin=conf.low, ymax=conf.high)) +
  geom_col(width = 0.6, position = position_dodge(0.7), colour="black") +
  geom_errorbar(width = 0.2, position = position_dodge(0.7), color="#707070") 



# subset partnered and unpartnered individuals. 
# Don’t have cohab indicator but can check ever married vs never married. evermar

## Original 4 categories
m1_evermar <- multinom(ideal ~ female + married + parent + evermar + essentialism_N, data, weights = weight)

## 6 categories at same time
m2_evermar <- multinom(ideal6 ~ female + married + parent + evermar + essentialism_N, data, weights = weight)


tidy(m1_evermar)
tidy(m2_evermar)

pp1_evermar       <- avg_predictions(m1_evermar, by = c("evermar"))

pp1_evermar %>%
  ggplot(aes(y = estimate, x = group, fill = fct_rev(evermar), ymin=conf.low, ymax=conf.high)) +
  geom_col(width = 0.6, position = position_dodge(0.7), colour="black") +
  geom_errorbar(width = 0.2, position = position_dodge(0.7), color="#707070") 

####  DO SAME THINGS FOR PARENT AND FULLTIME. AND THEN ONE MODEL WITH AGE2 ADDED TO IT