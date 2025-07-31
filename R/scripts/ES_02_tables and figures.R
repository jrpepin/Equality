#-------------------------------------------------------------------------------
# EVEN SHARING PROJECT
# ES_02_tables and figures.R
# Inés Martínez Echagüe & Joanna R. Pepin
#-------------------------------------------------------------------------------


# Table 01 Descriptive Statistics of Respondent Characteristics ----------------

tab01 <- data_svy %>%
  select("female", "married", "parent", 
         "educat", "racecat", "age") %>%
  tbl_svysummary(
    by    = female, 
    label = list(married         ~ "Married",
                 parent          ~ "Children under age 18 in household",
                 educat          ~ "Education group",
                 racecat         ~ "Respondent race/ethnicity",
                 age             ~ "Respondent age"),
    type  = list(married         ~ "dichotomous",
                 parent          ~ "dichotomous"),
    value = list(married         = "Married",
                 parent          = "HH child"),
    statistic = list(all_continuous() ~ "{mean} ({sd})", all_categorical() ~ "{p}"),
    digits = ~ c(2))  %>%
  add_overall() %>%
  modify_header(
    label = '**Variable**',
    stat_0 ~ "**Overall**, N = {N_unweighted} ({style_percent(p)}%)",     
    stat_1 ~ "**Men**, N = {n_unweighted} ({style_percent(p)}%)",     
    stat_2 ~ "**Women**, N = {n_unweighted} ({style_percent(p,digits = 1)}%)") %>%
  as_flex_table() %>%
  add_footer_lines("Source: 2018 YouGov original survey.")

tab01 # show table

## https://mran.microsoft.com/snapshot/2017-12-11/web/packages/officer/vignettes/word.html
read_docx() %>% 
  body_add_par("Table 1. Weighted descriptive statistics of the analytic sample") %>% 
  body_add_flextable(value = tab01) %>% 
  print(target = file.path(outDir, "ES_table01.docx"))

### Cell sizes

xtabs(~ female + married + parent, data = data)



# Table 02 ---------------------------------------------------------------------

tab02 <- data_svy %>%
  select("female", "ideal", "ideal6", "essentialism_N") %>%
  tbl_svysummary(
    by    = female, 
    label = list(ideal           ~ "4-category work-family arrangement",
                 ideal6          ~ "6-category work-family arrangement",
                 essentialism_N  ~ "Gender essentialism beliefs"),
    type  = list(essentialism_N  ~ "continuous"),
    statistic = list(all_continuous() ~ "{mean} ({sd})", all_categorical() ~ "{p}"),
    digits = ~ c(2))  %>%
  add_overall() %>%
  modify_header(
    label = '**Variable**',
    stat_0 ~ "**Overall**, N = {N_unweighted} ({style_percent(p)}%)",     
    stat_1 ~ "**Men**, N = {n_unweighted} ({style_percent(p)}%)",     
    stat_2 ~ "**Women**, N = {n_unweighted} ({style_percent(p,digits = 1)}%)") %>%
  as_flex_table() %>%
  add_footer_lines("Source: 2018 YouGov original survey.")

tab02 # show table

## https://mran.microsoft.com/snapshot/2017-12-11/web/packages/officer/vignettes/word.html
read_docx() %>% 
  body_add_par("Table 2. Weighted bivariate statistics") %>% 
  body_add_flextable(value = tab02) %>% 
  print(target = file.path(outDir, "ES_table02.docx"))

# Table 03 ---------------------------------------------------------------------

## Set reference levels
data$ideal <- relevel(data$ideal, ref = "Self-reliance")

## Original 4 categories
m1 <- multinom(ideal ~ female + married + parent + educat + racecat + age + essentialism_N, data, weights = weight)

## 6 categories at same time
m2 <- multinom(ideal6 ~ female + married + parent + educat + racecat + age + essentialism_N, data, weights = weight)

## Tidy and Relative Risk Ratios
#m1_tidy <- tidy(m1, conf.int = TRUE, exponentiate = TRUE)
#m2_tidy <- tidy(m2, conf.int = TRUE, exponentiate = TRUE)

#m1_tidy %>% 
 # kable() %>% 
 # kable_styling("basic", full_width = FALSE)


### AMEs
#ame_m1 <- avg_slopes(m1, by = "female")
#ame_m2 <- avg_slopes(m2, by = "female")

## Create list for 2 panels
panels <- list(
  "4 category model" = m1,
  "6 category model" = m2)

## Create pretty labels
coef_map1 <- c(
  "(Intercept)"                     = "Intercept",
  "femaleWomen"                     = "Women",
  "essentialism_N"                  = "Gender essentialism")

### Appendix Table
coef_map2 <- c(
  "marriedMarried"                  = "Married",
  "parentHH child"                  = "Household child",
  "educatSome college"              = "Some college",
  "educatBachelor's degree
or more"                            = "BA or more",
  "racecatBlack"                    = "Black",
  "racecatHispanic"                 = "Hispanic",
  "racecatOther"                    = "Other",
  "age"                             = "Age")

## Produce Table 03
tab03 <- modelsummary(
  panels,
  coef_map = coef_map1,
  shape = term + response ~ statistic,
  exponentiate = TRUE,
  gof_map = NA,
  estimate = "{estimate} ({std.error}) {stars} ",
  statistic = NULL,
  stars = c("*" =.05, "**" = .01, "***" = .001),
  fmt = fmt_decimal(digits = 2, pdigits = 3),
  output = "huxtable") %>%
  huxtable::as_flextable() %>%
  set_table_properties(layout = "autofit") %>%
  add_footer_lines("Notes: Standard errors in parentheses. Models include demographic variables (see Appendix Table A).")

tab03

read_docx() %>% 
  body_add_par("Table 3. Multinomial Regression Models (Relative Risk Ratios)") %>% 
  body_add_flextable(value = tab03) %>% 
  print(target = file.path(outDir, "ES_table03.docx"))


## Produce Appendix Table 01
tabA <- modelsummary(
  panels,
  coef_map = coef_map2,
  shape = term + response ~ statistic,
  exponentiate = TRUE,
  gof_map = NA,
  estimate = "{estimate} ({std.error}) {stars} ",
  statistic = NULL,
  stars = c("*" =.05, "**" = .01, "***" = .001),
  fmt = fmt_decimal(digits = 2, pdigits = 3),
  output = "huxtable") %>%
  insert_row(c("Education (ref = high school or less)", " ", " ", " "), 
             after = 13)  %>%
  insert_row(c("Race/ethnicity (ref = White)", " ", " ", " "), 
             after = 26) %>%
  huxtable::as_flextable() %>%
  set_table_properties(layout = "autofit") %>%
  add_footer_lines("Notes: Standard errors in parentheses. Models include gender and gender essentialism (see paper Table 2).")

tabA

read_docx() %>% 
  body_add_par("Appendix Table A. Multinomial Regression Models (Relative Risk Ratios)") %>% 
  body_add_flextable(value = tabA) %>% 
  print(target = file.path(outDir, "ES_tableA.docx"))


# Figure 01 --------------------------------------------------------------------

## Create predicted probabilities date sets
pp1        <- avg_predictions(m1)
pp1G       <- avg_predictions(m1, by = c("female"))
pp1$model  <- "4 work-family arrangements"
pp1G$model <- "4 work-family arrangements"
pp1$female <- "All"

## Create predicted probabilities date sets
pp2        <- avg_predictions(m2)
pp2G       <- avg_predictions(m2, by = c("female"))
pp2$model  <- "Subset of\n'sharing' arrangement"
pp2G$model <- "Subset of\n'sharing' arrangement"
pp2$female <- "All"

## Combine and clean the data sets
data_fig1 <- do.call("rbind", list(pp1, pp1G, pp2, pp2G))

data_fig1 <- data_fig1 %>%
  mutate(
    even = fct_case_when(
      group == "Self-reliance" | 
        group == "Provider"    | 
        group == "Homemaker"   ~ "uneven",
      group == "Sharing"       ~ "even",
      group == "Specialized"   |
        group == "Flexible"    |
        group == "Even"        ~ "sub-even"),
    female = fct_case_when(
      female == "All" ~ "All",
      female == "Men" ~ "Men",
      female == "Women" ~ "Women"),
    group = fct_case_when(
      group == "Self-reliance" ~ "Self-reliance",
      group == "Provider"      ~ "Provider",
      group == "Homemaker"     ~ "Homemaker",
      group == "Sharing"       ~ "Sharing\n(unspecified)",
      group == "Specialized"   ~ "Specialized\nsharing",
      group == "Flexible"      ~ "Flexible\nsharing",
      group == "Even"          ~ "Even\nsharing"))

## Create fig
fig1 <- data_fig1 %>%
  filter(
    model == "4 work-family arrangements" |
      model == "Subset of\n'sharing' arrangement" & even == "sub-even") %>%
  ggplot(aes(y = estimate, x = group, fill = fct_rev(female), ymin=conf.low, ymax=conf.high)) +
  geom_col(width = 0.6, position = position_dodge(0.7), colour="black") +
  geom_errorbar(width = 0.2, position = position_dodge(0.7), color="#707070") +
  geom_text(position = position_dodge(width = .7),
            hjust = -.8,
            size = 10/.pt,
            aes(label=sprintf("%1.0f%%", estimate*100))) +
  facet_grid(cols = vars(model),
             switch = "y",
             scales="free",
             space = "free") +
  theme_minimal() +
  theme(
    text                = element_text(size=12, family = "serif"),
    axis.text           = element_text(size=12, family = "serif"), 
    legend.text         = element_text(size=12, family = "serif"),
    legend.position     = "bottom",
    panel.grid.major.y  = element_blank(),
    strip.text          = element_text(face = "bold", size=12, family = "serif"),
    strip.placement     = "outside",               # Places the strip text on the outside 
    strip.text.y.left   = element_text(angle = 0),
    axis.text.x         = element_blank(),  #remove x axis labels
    axis.text.y         = element_text(colour = "black", face = "bold"),
    axis.ticks.y        = element_blank(),  #remove y axis ticks
    plot.subtitle       = element_text(face = "italic", color = "#707070"),
    plot.caption        = element_text(face = "italic", color = "#707070"),
    plot.title          = ggtext::element_markdown(),
    plot.title.position = "plot") +
  scale_y_continuous(labels=scales::percent, limits = c(0, .75)) +
  scale_x_discrete(limits=rev) +
  scale_fill_manual(values = c("grey70", "black", "white" )) +
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(
    #   title    = "XXX",
    #   subtitle = "YYY",
    #   caption  = "Note: ZZZ",
    fill     = NULL,
    x        = NULL, 
    y        = NULL) 

fig1

## save Figure 1
agg_tiff(filename = file.path(here(outDir, figDir), "fig1.tif"), 
         width=6.5, height=6.5, units="in", res = 800, scaling = 1)
plot(fig1)
invisible(dev.off())


# Figure 02 --------------------------------------------------------------------

## Create predicted probabilities date sets
data_fig2 <- avg_predictions(m2, variables = list(essentialism_N = c(1,2,3,4,5)))

data_fig2 <- data_fig2 %>%
  mutate(
    group = fct_case_when(
      group == "Self-reliance" ~ "Self-reliance",
      group == "Provider"      ~ "Provider",
      group == "Homemaker"     ~ "Homemaker",
      group == "Sharing"       ~ "Sharing\n(unspecified)",
      group == "Specialized"   ~ "Specialized\nsharing",
      group == "Flexible"      ~ "Flexible\nsharing",
      group == "Even"          ~ "Even\nsharing"))

fig2 <- data_fig2 %>%
  ggplot(aes(x = essentialism_N, y = estimate, ymin=conf.low, ymax=conf.high)) +
  geom_line() +
  geom_errorbar(width = 0.2, color="grey40") +
  geom_point() +
  facet_wrap("group", ncol = 3) +
  theme_minimal() +
  scale_x_reverse() +
  ylim(0, 0.5) +
  theme(
    text                = element_text(size=12, family = "serif"),
    axis.text           = element_text(size=12, family = "serif"), 
    legend.text         = element_text(size=12, family = "serif"),
    panel.grid.minor    = element_blank(),
    panel.grid.major.x  = element_blank(),
    axis.line           = element_line(), 
    strip.text          = element_text(face = "bold",    size=12, family = "serif"),
    axis.text.y         = element_text(colour = "black", size=12, family = "serif"),
    axis.text.x         = element_text(colour = "black", size=12, family = "serif"),
    axis.ticks.y        = element_blank(),  #remove y axis ticks
    plot.subtitle       = element_text(face = "italic", color = "#707070"),
    plot.caption        = element_text(face = "italic", color = "#707070"),
    plot.title          = ggtext::element_markdown(),
    plot.title.position = "plot") +
  labs(
    #   title    = "XXX",
    #   subtitle = "YYY",
    #   caption  = "Note: ZZZ",
    x        = "Gender essentialism", 
    y        = NULL) 

fig2

## save Figure 2
agg_tiff(filename = file.path(here(outDir, figDir), "fig2.tif"), 
         width=6.5, height=5, units="in", res = 800, scaling = 1)
plot(fig2)
invisible(dev.off())

# Figure 03 --------------------------------------------------------------------

## Create predicted probabilities date sets (for reference)
data_fig3 <- avg_predictions(m2, by = c("female", "essentialism_N"), 
                                variables = list(essentialism_N = c(1,2,3,4,5)))

data_fig3 <- data_fig3 %>%
  mutate(
    group = fct_case_when(
      group == "Self-reliance" ~ "Self-reliance",
      group == "Provider"      ~ "Provider",
      group == "Homemaker"     ~ "Homemaker",
      group == "Sharing"       ~ "Sharing\n(unspecified)",
      group == "Specialized"   ~ "Specialized\nsharing",
      group == "Flexible"      ~ "Flexible\nsharing",
      group == "Even"          ~ "Even\nsharing"))


fig3 <- data_fig3 %>%
  ggplot(aes(y = estimate, x = essentialism_N, fill = female, ymin=conf.low, ymax=conf.high)) +
  geom_col(width = 0.6, position = position_dodge(0.7), colour="black") +
  geom_errorbar(width = 0.2, position = position_dodge(0.7), color="#707070") +
  facet_wrap("group", ncol = 3) +
  theme_minimal() +
  scale_x_reverse() +
  theme(
    text                = element_text(size=12, family = "serif"),
    axis.text           = element_text(size=12, family = "serif"), 
    legend.text         = element_text(size=12, family = "serif"),
    legend.position     = "bottom",
    panel.grid.minor    = element_blank(),
    panel.grid.major.x  = element_blank(),
    axis.line           = element_line(), 
    strip.text          = element_text(face = "bold",    size=12, family = "serif"),
    axis.text.y         = element_text(colour = "black", size=12, family = "serif"),
    axis.text.x         = element_text(colour = "black", size=12, family = "serif"),
    axis.ticks.y        = element_blank(),  #remove y axis ticks
    plot.subtitle       = element_text(face = "italic", color = "#707070"),
    plot.caption        = element_text(face = "italic", color = "#707070"),
    plot.title          = ggtext::element_markdown(),
    plot.title.position = "plot") +
  scale_fill_manual(values = c("black", "grey70")) +
  labs(
    #   title    = "XXX",
    #   subtitle = "YYY",
    #   caption  = "Note: ZZZ",
    x        = "Gender essentialism", 
    y        = NULL,
    fill     = NULL)
#  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf),
#            data = ~ subset(., group %in% "Even\nsharing"), 
 #           colour = "black", fill = NA, inherit.aes = FALSE)

fig3

## save Figure 3
agg_tiff(filename = file.path(here(outDir, figDir), "fig3.tif"), 
         width=6.5, height=5, units="in", res = 800, scaling = 1)
plot(fig3)
invisible(dev.off())


## AMEs (For reference) --------------------------------------------------------

## Create AMEs
data_fig3_AME    <- avg_slopes(m2, by = c("essentialism_N"), variables = "female", 
                           newdata = datagrid(essentialism_N = c(1,2,3,4,5), 
                                              grid_type = "counterfactual"))

data_fig3_AME %>%
  ggplot(aes(y = estimate, x = essentialism_N, ymin=conf.low, ymax=conf.high)) +
  geom_col(width = 0.6, position = position_dodge(0.7), colour="black") +
  geom_errorbar(width = 0.2, position = position_dodge(0.7), color="grey70") +
  geom_hline(yintercept=0, linewidth=1) +
  facet_wrap("group", ncol = 3) +
  theme_minimal() +
  theme(
    text                = element_text(size=12, family = "serif"),
    axis.text           = element_text(size=12, family = "serif"), 
    legend.text         = element_text(size=12, family = "serif"),
    panel.grid.minor    = element_blank(),
    panel.grid.major.x  = element_blank(),
    axis.line           = element_line(), 
    strip.text          = element_text(face = "bold",    size=12, family = "serif"),
    axis.text.y         = element_text(colour = "black", size=12, family = "serif"),
    axis.text.x         = element_text(colour = "black", size=12, family = "serif"),
    axis.ticks.y        = element_blank(),  #remove y axis ticks
    plot.subtitle       = element_text(face = "italic", color = "#707070"),
    plot.caption        = element_text(face = "italic", color = "#707070"),
    plot.title          = ggtext::element_markdown(),
    plot.title.position = "plot") +
  scale_x_reverse() +
  labs(
    #   title    = "XXX",
    #   subtitle = "YYY",
    #   caption  = "Note: ZZZ",
    x        = "Gender essentialism", 
    y        = NULL) 