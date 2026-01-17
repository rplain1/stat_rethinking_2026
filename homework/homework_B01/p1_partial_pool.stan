data {
  int<lower=1> N;                      // number of observations
  array[N] int<lower=0, upper=1> W;    // weekend outcome variable column
  int<lower=1> n_countries;            // number of countries
  array[N] int<lower=1, upper=n_countries> country_idx;  // country index column
}

parameters {
  real alpha_bar;                      // population mean (hyperparameter)
  real<lower=0> sigma;                 // population sd (hyperparameter)
  vector[n_countries] alpha_z;         // standardized country offsets
}

transformed parameters {
  // vector[n_coutnries] means we will get the paramter
  // for each country

  vector[n_countries] alpha;           // country-level logit parameters
  vector[n_countries] mu_country;      // country-level probabilities

  // non-centered parameterization
  alpha = alpha_bar + sigma * alpha_z;
  mu_country = inv_logit(alpha);
}

model {
  // hyperpriors
  alpha_bar ~ normal(0, 1.5);
  sigma ~ exponential(1);

  // non-centered: sample from standard normal
  alpha_z ~ normal(0, 1);

  // likelihood
  W ~ bernoulli_logit(alpha[country_idx]);
}
