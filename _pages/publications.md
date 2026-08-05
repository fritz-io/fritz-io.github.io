---
title: "Publications"
permalink: /publications/
description: >-
  Preprints and peer-reviewed publications by Marvin Fritz in numerical analysis,
  partial differential equations, scientific computing, and mathematical modelling.
toc: true
toc_label: "Categories"
toc_icon: "book-open"
---

The list below is generated from
[`_data/publications.yml`](https://github.com/fritz-io/fritz-io.github.io/blob/main/_data/publications.yml).
Publication metadata, links, images, and numbering therefore have a single source of truth.

## Preprints

{% assign preprints = site.data.publications | where: "category", "preprint" %}
<ol class="publication-list" aria-label="Preprints">
{% for publication in preprints %}
  {% include publication-card.html publication=publication %}
{% endfor %}
</ol>

## Peer-reviewed scientific articles

{% assign articles = site.data.publications | where: "category", "article" %}
<ol class="publication-list" aria-label="Peer-reviewed scientific articles">
{% for publication in articles %}
  {% include publication-card.html publication=publication %}
{% endfor %}
</ol>
