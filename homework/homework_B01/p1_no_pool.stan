data {
  int<lower=1> N;
  array[N] int<lower=0, upper=1> W;
  int<lower=1> n_countries;
  array[N] int<lower=1, upper=n_countries> country_idx;
}

parameters {
  vector[n_countries] alpha;  // country-level logit parameters
}

transformed parameters {
  vector[n_countries] mu_country;  // country-level probabilities

  mu_country = inv_logit(alpha);
}

model {
  alpha ~ normal(0, 1.5);
  W ~ bernoulli_logit(alpha[country_idx]);
}
