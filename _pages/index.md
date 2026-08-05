---
layout: archive
permalink: /
description: >-
  Marvin Fritz is a tenure-track Professor of Numerical Analysis at the University
  of Vienna. His research concerns nonlinear and fractional partial differential
  equations, structure-preserving numerical methods, control, and mathematical
  models in the life sciences.
author_profile: true
classes: wide
---

<section id="about" class="site-intro" aria-labelledby="about-heading">
  <p class="eyebrow">Numerical analysis · Partial differential equations</p>
  <h1 id="about-heading">Marvin Fritz</h1>

  <p class="lede">
    Marvin Fritz is a tenure-track Professor of Numerical Analysis at the
    <a href="https://www.univie.ac.at/">University of Vienna</a>.
  </p>

  <p>
    His research concerns the analysis and numerical approximation of nonlinear,
    fractional, nonlocal, and stochastic partial differential equations. A central
    theme is the development of reliable computational methods that preserve the
    mathematical structure of models arising in materials science, control,
    mechanics, nonlinear acoustics, and mathematical biology.
  </p>

  <nav class="section-nav" aria-label="On this page">
    <a href="#research">Research</a>
    <span aria-hidden="true">·</span>
    <a href="#meet">Upcoming talks</a>
    <span aria-hidden="true">·</span>
    <a href="#publications">Publications</a>
  </nav>
</section>

<section id="research" class="one-page-section" aria-labelledby="research-heading">
  <h2 id="research-heading">Research</h2>
  <p class="section-intro">
    My work combines analytical questions—existence, uniqueness, regularity,
    stability, and long-time behaviour—with numerical methods designed to retain
    the structure of the underlying model.
  </p>

  <article class="research-area">
    <div class="research-area__text">
      <h3>Structure-preserving discretization</h3>
      <p>
        Many evolution equations encode conservation laws, energy dissipation,
        positivity, or thermodynamic consistency. I study finite-element and
        time-stepping methods that preserve these properties at the discrete level,
        particularly for Cahn–Hilliard-type equations and coupled multiphysics models.
      </p>
    </div>

    <div class="research-gallery" aria-label="Simulations for structure-preserving discretization">
      <figure class="research-figure">
        <a href="#pub30">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/highorder.png' | relative_url }}"
              alt="Numerical simulation for a high-order conforming finite-element method for the Cahn–Hilliard equation"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>High-order Cahn–Hilliard discretization</figcaption>
        </a>
      </figure>

      <figure class="research-figure">
        <a href="#pub21">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/ohta-removebg-preview.png' | relative_url }}"
              alt="Pattern-formation simulation for the Ohta–Kawasaki equation"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>Ohta–Kawasaki pattern formation</figcaption>
        </a>
      </figure>
    </div>
  </article>

  <article class="research-area">
    <div class="research-area__text">
      <h3>Fractional, nonlocal, and stochastic equations</h3>
      <p>
        Fractional derivatives and nonlocal operators describe memory, anomalous
        diffusion, and long-range interactions. My work addresses well-posedness,
        energy behaviour, order perturbations, random forcing, and computable
        approximations for such models.
      </p>
    </div>

    <div class="research-gallery" aria-label="Simulations for fractional and nonlocal equations">
      <figure class="research-figure">
        <a href="#pub35">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/voronoi.png' | relative_url }}"
              alt="Subdiffusive grain-growth simulation with a Voronoi-like structure"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>Subdiffusive grain growth</figcaption>
        </a>
      </figure>

      <figure class="research-figure">
        <a href="#pub13">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/Fokker2.png' | relative_url }}"
              alt="Probability-density simulation for a time-fractional Fokker–Planck equation"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>Time-fractional Fokker–Planck dynamics</figcaption>
        </a>
      </figure>
    </div>
  </article>

  <article class="research-area">
    <div class="research-area__text">
      <h3>Control, coupled systems, and nonlinear acoustics</h3>
      <p>
        I investigate feedback stabilization and numerical control for nonlinear
        PDEs, together with coupled systems arising from flow, poroelasticity,
        transport, and wave propagation. A recurring goal is to connect rigorous
        stability analysis with implementable algorithms.
      </p>
    </div>

    <div class="research-gallery" aria-label="Simulations for control and coupled systems">
      <figure class="research-figure">
        <a href="#pub20">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/IMG_2338.webp' | relative_url }}"
              alt="Controlled phase-field evolution for feedback stabilization of a Cahn–Hilliard equation"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>Cahn–Hilliard feedback stabilization</figcaption>
        </a>
      </figure>

      <figure class="research-figure">
        <a href="#pub18">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/Actuator.png' | relative_url }}"
              alt="Actuator configuration for stabilization of a nonisothermal Cahn–Hilliard system"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>Actuator-based trajectory stabilization</figcaption>
        </a>
      </figure>
    </div>
  </article>

  <article class="research-area">
    <div class="research-area__text">
      <h3>Mathematical models in the life sciences</h3>
      <p>
        Phase-field, transport, tissue-mechanics, and vascular-network models make
        it possible to study interacting biological processes across scales.
        Applications include tumor evolution, angiogenesis, immunotherapy, digit
        morphogenesis, and biological damage and repair.
      </p>
    </div>

    <div class="research-gallery" aria-label="Simulations for mathematical life-science models">
      <figure class="research-figure">
        <a href="#pub31">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/fingering.png' | relative_url }}"
              alt="Fingering-pattern simulation for traction-driven digit morphogenesis"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>Traction-driven digit morphogenesis</figcaption>
        </a>
      </figure>

      <figure class="research-figure">
        <a href="#pub5">
          <span class="research-figure__canvas">
            <img
              src="{{ '/assets/images/modeling3.png' | relative_url }}"
              alt="Simulation of a vascular tumor embedded in an evolving capillary network"
              loading="lazy"
              decoding="async">
          </span>
          <figcaption>Vascular tumors and capillary networks</figcaption>
        </a>
      </figure>
    </div>
  </article>
</section>

<section id="meet" class="one-page-section" aria-labelledby="meet-heading">
  <h2 id="meet-heading">Upcoming talks &amp; conferences</h2>

  <div class="upcoming-events">
    <article class="upcoming-event">
      <time datetime="2027-03-08">8–12 March 2027</time>
      <div>
        <h3>
          <a href="https://jahrestagung.gamm.org/joint-annual-meeting-2027/joint-annual-meeting/">
            Joint Annual Meeting of GAMM and DMV
          </a>
        </h3>
        <p>Ulm, Germany</p>
      </div>
    </article>

    <article class="upcoming-event">
      <time datetime="2027-07-05">5–9 July 2027</time>
      <div>
        <h3>
          <a href="https://icosahom2027.org/">
            16th International Conference on Spectral and High Order Methods
          </a>
        </h3>
        <p>Milan, Italy</p>
      </div>
    </article>
  </div>
</section>

<section id="publications" class="one-page-section" aria-labelledby="publications-heading">
  <h2 id="publications-heading">Publications</h2>
  <div class="publication-list" role="list" aria-label="Publications by Marvin Fritz">
  {% for publication in site.data.publications %}
    {% include publication-card.html publication=publication %}
  {% endfor %}
  </div>
</section>

<p class="back-to-top"><a href="#about">Back to top ↑</a></p>
