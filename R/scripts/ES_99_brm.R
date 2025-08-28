# Load the package
library(brms)

# Fit the model
fit <- brm(
  formula = ideal_3 ~ female + married + parent + educat + racecat + age + essentialism_N,
  data = data,
  family = categorical(),
  chains = 4, iter = 2000, warmup = 500
)

# View results
summary(fit)

pp_check(fit)

pp_blm1        <- avg_predictions(fit)


# Fit the model with priors

# Weakly informative priors

## Why Normal(0, 2.5)?
## The mean of 0 reflects no prior bias toward positive or negative effects.
## The standard deviation of 2.5 allows for a wide range of plausible values.
## In logistic models, a coefficient of ±2.5 corresponds to an odds ratio of about 12 or 1/12—a large effect, but not absurd.

prior <- c(
  prior(normal(0, 2.5), class = "b", dpar = "muSharing"),
  prior(normal(0, 2.5), class = "b", dpar = "muProviderHomemaker"),
  prior(normal(0, 5), class = "Intercept", dpar = "muSharing"),
  prior(normal(0, 5), class = "Intercept", dpar = "muProviderHomemaker")
)

fit <- brm(
  formula = ideal_3 ~ female + married + parent + educat + racecat + age + essentialism_N,
  data = data,
  family = categorical(),
  prior = prior,
  chains = 4, iter = 2000, warmup = 500
)

# View results
summary(fit)

pp_check(fit)

pp_blm1b        <- avg_predictions(fit)
