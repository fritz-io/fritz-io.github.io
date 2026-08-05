---
layout: archive
permalink: /
description: >-
  Marvin Fritz is a tenure-track Professor at the University of Vienna working
  on numerical analysis of PDEs, mathematical modelling, and computational science.
author_profile: true
classes: wide
---

<section class="profile-intro" aria-labelledby="intro-heading">
  <div class="profile-intro__content">
    <p class="eyebrow">Numerical analysis · PDEs · Mathematical modelling</p>
    <h1 id="intro-heading">Marvin Fritz</h1>
    <p class="profile-intro__tagline">Reliable mathematics and computation for complex systems</p>

    <p class="lede">
      I am a tenure-track Professor at the
      <a href="https://www.univie.ac.at/">University of Vienna</a>.
      I develop mathematical theory and reliable numerical methods for nonlinear,
      fractional, and stochastic partial differential equations.
    </p>

    <p>
      My work connects structure-preserving computation with applications in
      materials, mechanics, control, nonlinear acoustics, and mathematical biology.
    </p>

    <p class="button-row">
      <a class="btn btn--primary" href="{{ '/publications/' | relative_url }}">View publications</a>
      <a class="btn" href="{{ '/assets/CV.pdf' | relative_url }}">Download CV</a>
      <a class="btn" href="{{ '/research/' | relative_url }}">Research overview</a>
      <a class="btn" href="mailto:marvin.fritz@univie.ac.at">Email</a>
    </p>
  </div>

  <figure class="profile-intro__media">
    <img
      src="{{ '/assets/images/research.webp' | relative_url }}"
      alt="Composite research illustration showing a surface plot, a simulated flow field, and a phase-field shape with equations"
      width="1200"
      height="1701"
      decoding="async"
      fetchpriority="high">
  </figure>
</section>

## Research themes

<div class="research-grid">
  <article class="research-card">
    <h3>Structure-preserving numerics</h3>
    <p>
      Stable finite-element and time-discretization methods that retain energy,
      mass, entropy, and other structural properties of the underlying model.
    </p>
  </article>

  <article class="research-card">
    <h3>Fractional and stochastic PDEs</h3>
    <p>
      Well-posedness, memory effects, anomalous diffusion, random forcing, and
      numerical approximation for systems beyond classical integer-order dynamics.
    </p>
  </article>

  <article class="research-card">
    <h3>Control and multiphysics</h3>
    <p>
      Feedback stabilization, model coupling, poroelasticity, fluid interaction,
      mixed-dimensional systems, and nonlinear acoustics.
    </p>
  </article>

  <article class="research-card">
    <h3>Life-science models</h3>
    <p>
      Phase-field, transport, vascular-network, and tissue-mechanics models for
      tumor growth, morphogenesis, biological damage, and repair.
    </p>
  </article>
</div>

## Selected publications

<div class="selected-publications">
{% assign selected_publications = site.data.publications | where: "selected", true %}
{% for publication in selected_publications %}
  <article class="selected-publication">
    <p class="selected-publication__meta">
      {{ publication.venue }}{% if publication.year %} · {{ publication.year }}{% endif %}
    </p>
    <h3>
      <a href="{{ '/publications/' | relative_url }}#pub{{ publication.number }}">
        {{ publication.title }}
      </a>
    </h3>
    <p>{{ publication.summary }}</p>
    <p class="selected-publication__links">
      {% if publication.arxiv %}<a href="{{ publication.arxiv }}">Preprint</a>{% endif %}
      {% if publication.doi %}<a href="{{ publication.doi }}">Published article</a>{% endif %}
    </p>
  </article>
{% endfor %}
</div>

<p class="section-link">
  <a href="{{ '/publications/' | relative_url }}">Browse the complete publication list →</a>
</p>
