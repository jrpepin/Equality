#-------------------------------------------------------------------------------
# EVEN SHARING PROJECT
# ES_01_measures and sample.R
# Inés Martínez Echagüe & Joanna R. Pepin
#-------------------------------------------------------------------------------

# Project Environment ----------------------------------------------------------
## The ES_00-1_setup and packages.R script should be run before this script

# source(ES_00-1_setup and packages.R)

## Load the data ---------------------------------------------------------------
data <- read_dta(file.path(dataDir, rawdata))   # load the raw data file

## Load the data and create a new df containing only the variables of interest.  
data <- data %>%
  # Create an ID variable
  mutate(ID = row_number()) %>%
  select(caseid, weight,                              # Survey variables
         gender, birthyr, race, educ,                # Demographic     
         marstat, child18,
         division_of_labor, ideal_arrangement,        # Project specific
         future, future_sharing, 
         future_sharing_arrangement,           
         essentialism, scarce, menlead, fathers, 
         decisions, time)

## Sample size
count(data)


# VARIABLES --------------------------------------------------------------------

## Demographic Variables
data <- data %>%
  mutate(
    # Gender
    female = fct_case_when(
      gender   == 1                            ~ "Men",
      gender   == 2                            ~ "Women", 
      TRUE                                     ~  NA_character_),
    # Age
    age = 2019 - birthyr,
    # Race
    racecat = fct_case_when(
      race   == 1                              ~ "White",
      race   == 2                              ~ "Black", 
      race   == 3                              ~ "Hispanic",
      race   >= 4                              ~ "Other", 
      TRUE                                     ~  NA_character_),
    # Education group
    educat = fct_case_when(
      educ   == 1 | educ == 2                  ~ "High school\nor less",
      educ   == 3 | educ == 4                  ~ "Some college", 
      educ   == 5 | educ == 6                  ~ "Bachelor's degree\nor more",
      TRUE                                     ~  NA_character_),
    # Marital status
    married = fct_case_when(
      marstat!=1 & marstat != 6                ~ "Not married", 
      marstat==1 | marstat == 6                ~ "Married",
      TRUE                                     ~  NA_character_),
    # Children under age 18 in household
    parent = fct_case_when(
      child18==1                               ~ "No HH child",
      child18==2                               ~ "HH child",
      TRUE                                     ~  NA_character_))   


## Project Variables
data <- data %>%
  mutate(
    # Current work-family arrangement
    wfaNow = fct_case_when(
      division_of_labor   == 1                  ~ "No WFA",
      division_of_labor   >= 2 & 
        division_of_labor <= 5                  ~ "WFA",
      TRUE                                      ~  NA_character_),
    # Ideal work-family arrangement
    ideal = fct_case_when(
      ideal_arrangement==1  | future == 1       ~ "Self-reliance",
      ideal_arrangement==2  | future == 2       ~ "Provider",
      ideal_arrangement==3  | future == 3       ~ "Homemaker",
      ideal_arrangement==4  | future == 4       ~ "Sharing",
      TRUE                                      ~  NA_character_),
    # Ideal sharing arrangement
    share = fct_case_when(
      future_sharing==1 | 
        future_sharing_arrangement == 1         ~ "Equally\nHome Centered",
      future_sharing==2 | 
        future_sharing_arrangement == 2         ~ "Equally\nBalanced",
      future_sharing==3 | 
        future_sharing_arrangement == 3         ~ "Equally\nCareer-centered",
      future_sharing==4 | 
        future_sharing_arrangement == 4         ~ "Flexible",
      future_sharing==5 | 
        future_sharing_arrangement == 5         ~ "Family centered\nPrimary",
      future_sharing==6 | 
        future_sharing_arrangement == 6         ~ "Family centered\nSecondary",
      TRUE                                      ~  NA_character_),
    # Ideal sharing arrangement (3 categories)
    share3 = fct_case_when(
      share=="Family centered\nPrimary"         | 
        share=="Family centered\nSecondary"     ~ "Specialized",
      share=="Flexible"                         ~ "Flexible",
      share=="Equally\nHome Centered"           | 
        share=="Equally\nBalanced"              | 
        share=="Equally\nCareer-centered"       ~ "Equally",
      TRUE                                      ~  NA_character_),
    # Ideal arrangements (6 categories)
    ideal6 = fct_case_when(
      ideal  == "Self-reliance"                 ~ "Self-reliance",
      ideal  == "Provider"                      ~ "Provider",
      ideal  == "Homemaker"                     ~ "Homemaker",
      share3 == "Specialized"                   ~ "Specialized",
      share3 == "Flexible"                      ~ "Flexible",
      share3 == "Equally"                       ~ "Equally",
      TRUE                                      ~  NA_character_),
    # 1 missing case
    essentialism = na_if(essentialism, 8))
    
# Prep scale variables
data <- data %>%
  # identify as numeric variables
  mutate_at(c("essentialism", "scarce", "menlead", 
              "fathers", "decisions", "time"), 
            list(N = as.numeric)) %>%
  # Standardize new variables
  mutate(across(
    .cols = contains('_N'), 
    .fns = scale,
    .names = "{.col}_std")) %>%
  # Back to numeric variable
  mutate(across(contains('_N'), \(x) as.numeric(x))) %>%
  # Round to 2 decimal places
  mutate(across(contains('_N_std'), \(x) round(x, 2)))


# Sample -----------------------------------------------------------------------
glimpse(data)

## Original sample size
count(data)

## Missing data  
colSums(is.na(data))

data <- data %>%
  # exclude cases missing on DVs
  drop_na(c(essentialism, wfaNow, ideal6)) 

# Analytic sample size
count(data)


## Construct Scales ------------------------------------------------------------
### make after drop missing obvs

cor_matrix <- cor(data[, c('essentialism_N', 'scarce_N', 'menlead_N', 'fathers_N',
                           'decisions_N', 'time_N')], use = "pairwise.complete.obs")
p0 <- ggcorrplot(cor_matrix, type = "lower", lab = TRUE)

p0

ggsave(file.path(here(outDir, figDir),"alphas.png"), p0, width = 6.5, height = 6.5, dpi = 300, bg = 'white')

# Generate the alphas
alphas_all <- data %>%
  select('essentialism_N', 'scarce_N', 'menlead_N', 'fathers_N',
         'decisions_N', 'time_N') %>%
  cov() %>%
  psych::alpha(., check.keys = TRUE)

## remove time
alphas_5 <- data %>%
  select('essentialism_N', 'scarce_N', 'menlead_N', 'fathers_N',
         'decisions_N') %>%
  cov() %>%
  psych::alpha(., check.keys = TRUE)

## remove time & fathers
alphas_4 <- data %>%
  select('essentialism_N', 'scarce_N', 'menlead_N', 'decisions_N') %>%
  cov() %>%
  psych::alpha(., check.keys = TRUE)

index <- c('alphas_all', 'alphas_5', 'alphas_4')
alphas <- c(alphas_all$total$raw_alpha, alphas_5$total$raw_alpha, 
            alphas_4$total$raw_alpha)
alpha_df <- data.frame(index, alphas)
alpha_df$alphas <- round(alpha_df$alphas, digits = 2)
write_xlsx(alpha_df, path = file.path(outDir, "alphas.xlsx"))

remove(cor_matrix, alphas_all, alphas_5, alphas_4)

scoring_key = list(
  attitudes = c('essentialism_N', 'scarce_N', 'menlead_N', 'decisions_N'))

scales <- as_tibble(psych::scoreFast(
  keys   = scoring_key, 
  items  = data,
  totals = FALSE)) # average scores

data$attitudes      <- scales$`attitudes-A`

data <- data %>%
# Standardize new scale
mutate(across(
  .cols = c('attitudes'), 
  .fns = scale,
  .names = "{.col}_std")) %>%
  # Back to numeric variable
  mutate(across(c('attitudes_std'), as.numeric)) %>%
  # Round to 2 decimal places
  mutate(across(c('attitudes_std'), round, 2))


# Keep processed project variables ---------------------------------------------
data <- data %>%
  select(caseid, weight, female, married, parent, educat, racecat, age,
         wfaNow, ideal, ideal6, share, share3, 
         attitudes, essentialism, scarce, menlead, fathers, decisions, time)

## Clean up global environment
remove(scoring_key, p0, scales, alpha_df)

# Create survey data -----------------------------------------------------------
data_svy <- data %>%
  # weight data
  as_survey_design(id = 1,
                   weights = weight)

message("End of ES_01_measures and sample") # Marks end of R Script

