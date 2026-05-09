---
layout: paper
title: "Identifiable latent bandits"
permalink: /identifiable-latent-bandits/
hide_masthead: true
description: "Combining observational data and exploration for personalized healthcare"
paper_title: "Identifiable latent bandits"
paper_description: "Combining observational data and exploration for personalized healthcare"
paper_venue: "Transactions on Machine Learning Research"
paper_authors:
  - name: "Ahmet Zahid Balcıoğlu"
  - name: "Newton Mwai"
  - name: "Emil Carlsson"
  - name: "Fredrik D. Johansson"
paper_links:
  - label: "arXiv"
    url: "https://arxiv.org/abs/2407.16239"
    icon: "ai ai-arxiv"
  - label: "GitHub"
    url: "https://github.com/Healthy-AI/identifiable-latent-bandits-public"
    icon: "fab fa-github"
paper_sections:
  - title: "abstract"
    paragraphs:
      - >
        Sequential decision-making algorithms such as multi-armed bandits can find optimal personalized decisions, but are notoriously sample-hungry. In personalized medicine, for example, training a bandit from scratch for every patient is typically infeasible, as the number of trials required is much larger than the number of decision points for a single patient. To combat this, latent bandits offer rapid exploration and personalization beyond what context variables alone can offer, provided that a latent variable model of problem instances can be learned consistently. However, existing works give no guidance as to how such a model can be found. In this work, we propose an identifiable latent bandit framework that leads to optimal decision-making with a shorter exploration time than classical bandits by learning from historical records of decisions and outcomes. Our method is based on nonlinear independent component analysis that provably identifies representations from observational data sufficient to infer optimal actions in new bandit instances. We verify this strategy in simulated and semi-synthetic environments, showing substantial improvement over online and offline learning baselines when identifying conditions are satisfied.
  - title: "video"
    placeholder: "Video placeholder"
  - title: "key contributions"
    items:
      - >
        Introduces identifiable latent bandits, a family of latent bandit algorithms that recover a continuous vector-valued latent state without assuming that the latent variable model is known in advance.
      - >
        Builds on nonlinear independent component analysis and introduces mean-contrastive learning to learn the latent variable model from observational histories.
      - >
        Proves that the learned representation is identifiable up to the invariances needed for optimal decision-making, then proposes decision-making algorithms that exploit the learned latent variable model in a regret-minimization setting.
      - >
        Shows empirically that, when the identifying conditions hold, the algorithms are more sample-efficient than online bandits, less biased than offline regression baselines, and effective in a semi-synthetic Alzheimer's disease treatment environment.
  - title: "offline setting"
    paragraphs:
      - >
        In the offline phase, identifiable latent bandits learn from observational histories of previous problem instances. The method trains a feature extractor <code>f</code> by predicting which instance generated each context observation, a mean-contrastive learning task inspired by identifiable representation learning.
    items:
      - >
        <strong>Identifiability theorem.</strong> Under the structural and learning assumptions in the paper, the optimal feature extractor <code>f*</code> is equal to the inverse emission function <code>g^{-1}</code> up to an invertible affine transformation: <code>B f*(x) + b = g^{-1}(x)</code>.
      - >
        This affine identifiability is enough for decision-making because the latent state can be estimated from repeated contexts, and action rankings are preserved once the reward model is fit in the learned representation.
      - >
        With linear reward means <code>mu_a(z) = theta_a^T z</code>, the state-conditional interventional reward <code>E[R | Z=z, do(A=a)]</code> is identifiable from observational data by OLS on observed rewards and inferred latent states.
  - title: "online setting"
    paragraphs:
      - >
        At decision time, a new instance produces noisy contexts over rounds. The algorithm averages the learned representation of the observed contexts to estimate the instance latent state, then uses the reward model learned offline to choose actions.
      - >
        The paper studies context posterior greedy, full posterior greedy, and an exploratory posterior-sampling variant. Context posterior greedy uses only the inferred latent state; full posterior greedy also uses reward history to refine the latent estimate; the exploratory variant samples reward means to reduce uncertainty.
    items:
      - >
        <strong>Regret result.</strong> If the learned model pair has uniform reward-prediction error below <code>epsilon</code>, then the expected regret of context posterior greedy is bounded by <code>1[epsilon &lt; Delta_i/2] * 8 K sigma^2 overline{Delta}_i / (Delta_i - 2 epsilon)^2 + 1[epsilon &gt;= Delta_i/2] * (8 K sigma^2 overline{Delta}_i / Delta_i^2 + 2 epsilon T + Delta_i T / 2)</code>.
      - >
        For an optimal learned model pair, <code>epsilon = 0</code>, the bound is constant in the horizon <code>T</code>. When the model error is too large to separate the best arm from close competitors, the regret bound becomes linear.
paper_bibtex: |
  @article{balcioglu2026identifiable,
    title   = {{Identifiable Latent Bandits}: Leveraging observational data for personalized decision-making},
    author  = {Balc{\i}o{\u{g}}lu, Ahmet Zahid and Mwai, Newton and Carlsson, Emil and Johansson, Fredrik D.},
    journal = {Transactions on Machine Learning Research},
    year    = {2026},
    url     = {https://openreview.net/forum?id=SvkZ76wKpu}
  }
---
