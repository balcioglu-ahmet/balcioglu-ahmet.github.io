---
layout: paper
title: "Identifiable latent bandits"
permalink: /identifiable-latent-bandits/
hide_masthead: true
description: "Leveraging observational data for personalized decision-making"
paper_title: "Identifiable Latent Bandits: Leveraging observational data for personalized decision-making"
paper_description: "A framework for learning latent bandit models from observational histories, then using them for faster personalized sequential decision-making."
paper_authors:
  - name: "Ahmet Zahid Balcıoğlu"
  - name: "Newton Mwai"
  - name: "Emil Carlsson"
  - name: "Fredrik D. Johansson"
paper_links:
  - label: "arXiv"
    url: "https://arxiv.org/abs/2407.16239"
    icon: "ai ai-arxiv"
  - label: "OpenReview"
    url: "https://openreview.net/forum?id=SvkZ76wKpu"
    icon: "fas fa-comment-alt"
  - label: "Code"
    url: "https://github.com/Healthy-AI/identifiable-latent-bandits-public"
    icon: "fab fa-github"
paper_sections:
  - title: "Abstract"
    image:
      src: "/assets/papers/identifiable-latent-bandits/images/ilb-illustration.png"
      alt: "Identifiable latent bandits learn a latent variable model offline and use it online to choose actions."
      caption: "Offline, identifiable latent bandits learn a latent variable model from historical context-action-reward trajectories. Online, the learned model helps infer a new instance's latent state and select actions."
    paragraphs:
      - >
        Sequential decision-making algorithms such as multi-armed bandits can find optimal personalized decisions, but are notoriously sample-hungry. In personalized medicine, for example, training a bandit from scratch for every patient is typically infeasible, as the number of trials required is much larger than the number of decision points for a single patient. To combat this, latent bandits offer rapid exploration and personalization beyond what context variables alone can offer, provided that a latent variable model of problem instances can be learned consistently. However, existing works give no guidance as to how such a model can be found.
      - >
        In this work, we propose an identifiable latent bandit framework that leads to optimal decision-making with a shorter exploration time than classical bandits by learning from historical records of decisions and outcomes. Our method is based on nonlinear independent component analysis that provably identifies representations from observational data sufficient to infer optimal actions in new bandit instances. We verify this strategy in simulated and semi-synthetic environments, showing substantial improvement over online and offline learning baselines when identifying conditions are satisfied.
        Identifiable latent bandits use observational histories from previous instances to learn the hidden structure shared across individuals. The learned representation is then used online to infer a new instance's latent state from repeated contexts and choose actions with less exploration.
  - title: "Contributions"
    cards_layout: "scroll"
    cards:
      - label: "1"
        title: "Learn latent bandit models"
        text: "Introduces identifiable latent bandits, a family of latent bandit algorithms that recover a continuous vector-valued latent state without assuming the latent variable model is known in advance."
      - label: "2"
        title: "Mean-contrastive representation learning"
        text: "Builds on nonlinear ICA and introduces mean-contrastive learning to identify the latent variable model from observational histories."
      - label: "3"
        title: "Identifiability for decisions"
        text: "Proves that the learned representation is identifiable to the degree needed for optimal decision-making, then uses it in sequential regret-minimization algorithms."
      - label: "4"
        title: "Empirical sample-efficiency"
        text: "Shows that, when identifying conditions hold, the algorithms improve over online bandits and offline regression baselines in synthetic and semi-synthetic treatment environments."
  - title: "Video"
    video:
      src: "/assets/papers/identifiable-latent-bandits/video/ilb-placeholder.mp4"
      poster: "/assets/papers/identifiable-latent-bandits/video/ilb-placeholder-poster.png"
      caption: "Placeholder video for the identifiable latent bandits project page."
  - title: "Research Question"
    cards:
      - label: "Why latent bandits?"
        title: "Context alone is not enough"
        text: "A single observed context can be noisy and incomplete. The optimal action may depend on a stable latent state that only becomes clear across repeated observations."
      - label: "Why identifiability?"
        title: "Many latent models fit the same data"
        text: "A learned latent model must recover the structure needed for decisions, not just reconstruct observations. The paper gives conditions under which this recovery is possible."
      - label: "Why observational data?"
        title: "Exploration is expensive"
        text: "Historical decisions and outcomes can warm-start personalization, reducing the amount of online exploration required for a new instance."
  - title: "Offline Data: Identifiability & Estimation"
    paragraphs:
      - >
        The offline stage learns an inverse emission model. Contexts are generated by a smooth injective emission function applied to a noisy latent state. We train a feature extractor <code>f</code> with a mean-contrastive objective: given a context observation, predict which historical instance generated it.
      - >
        Once this feature extractor is learned, repeated contexts from an instance can be averaged in representation space to estimate the latent state. A reward model is then fit from inferred latent states and observed rewards, giving action-value estimates for online decision-making.
    figures:
      - src: "/assets/papers/identifiable-latent-bandits/images/ilb-assumptions.png"
        alt: "Structural causal model for identifiable latent bandits."
        caption: "The assumed causal structure for a problem instance: a stable latent state generates noisy time-varying states and contexts, while actions and latent state determine rewards."
        size: "compact"
  - title: "Theoretical Guarantees"
    paragraphs:
      - >
        The paper proves that the learned representation is identifiable up to the affine transformations that still preserve the action rankings needed for optimal decisions. It then shows that the corresponding reward model is identifiable from observational data, and that context posterior greedy has constant regret when the learned model is accurate enough.
    figures:
      - src: "/assets/papers/identifiable-latent-bandits/images/theorem-inverse-emission.png"
        alt: "Theorem: identifiability of inverse emission function."
        caption: "The learned feature extractor recovers the inverse emission function up to an invertible affine transformation."
      - src: "/assets/papers/identifiable-latent-bandits/images/theorem-reward-identifiability.png"
        alt: "Theorem: identifiability of decision-making criteria."
        caption: "The state-conditional interventional reward is identifiable from observational trajectories under the structural assumptions."
      - src: "/assets/papers/identifiable-latent-bandits/images/theorem-cpg-regret.png"
        alt: "Theorem: context posterior greedy regret bound."
        caption: "When model error is small enough to separate the best arm, context posterior greedy has regret independent of the horizon."
  - title: "Online Decision-Making"
    cards:
      - label: "CPG"
        title: "Context posterior greedy"
        text: "Uses the average learned representation of observed contexts to estimate the latent state, then acts greedily under the offline reward model."
      - label: "FPG"
        title: "Full posterior greedy"
        text: "Refines the latent-state estimate using both context history and observed rewards, making it more adaptive when the representation is biased."
      - label: "FPG-TS"
        title: "Exploratory posterior sampling"
        text: "Samples reward means under the posterior to trade off fast personalization with recovery from uncertainty or misspecification."
  - title: "Experiments"
    paragraphs:
      - >
        In synthetic and semi-synthetic Alzheimer's disease treatment environments, identifiable latent bandits converge faster than fully online bandits and avoid much of the bias seen in direct regression baselines when the identifying assumptions hold.
      - >
        The experiments also map the limitations: as latent-state noise, context noise, out-of-distribution shift, or the number of arms increases, the tradeoff between fast offline transfer and unbiased online exploration becomes more visible.
    figures:
      - src: "/assets/papers/identifiable-latent-bandits/images/results-synthetic.png"
        alt: "Synthetic environment cumulative regret results."
        caption: "Synthetic environment: learned latent bandits approach oracle behavior and improve over online-only and regression baselines."
      - src: "/assets/papers/identifiable-latent-bandits/images/results-adcb.png"
        alt: "ADCB cumulative regret results."
        caption: "ADCB treatment simulator: learned latent models accelerate personalization in a semi-synthetic healthcare setting."
      - src: "/assets/papers/identifiable-latent-bandits/images/results-ood.png"
        alt: "Out-of-distribution cumulative regret results."
        caption: "Out-of-distribution shifts reveal where adaptive latent-state inference becomes important."
      - src: "/assets/papers/identifiable-latent-bandits/images/results-emission-noise.png"
        alt: "Context emission noise cumulative regret results."
        caption: "Increasing context noise stresses the learned latent variable model and highlights the benefit of adaptive variants."
  - title: "Takeaway"
    paragraphs:
      - >
        The central message is that latent bandits do not need to assume their latent variable model is known in advance. Under identifiable structure, the model can be learned from observational histories and then used to reduce online exploration for future personalized decisions.
    items:
      - >
        Identifiability is used for decision-making, not merely representation recovery.
      - >
        The affine ambiguity in the learned representation is harmless once the reward model is fit in the same representation.
      - >
        Offline data can make sequential personalization much faster, but online exploration remains valuable when the learned latent model is biased or extrapolating.
paper_bibtex: |
  @article{balcioglu2026identifiable,
    title   = {{Identifiable Latent Bandits}: Leveraging observational data for personalized decision-making},
    author  = {Balc{\i}o{\u{g}}lu, Ahmet Zahid and Mwai, Newton and Carlsson, Emil and Johansson, Fredrik D.},
    journal = {Transactions on Machine Learning Research},
    year    = {2026},
    url     = {https://openreview.net/forum?id=SvkZ76wKpu}
  }
---
