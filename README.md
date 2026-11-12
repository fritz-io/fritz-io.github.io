# marvinfritz.de

Academic website of Marvin Fritz, built with Jekyll and the Minimal Mistakes remote theme.

## Local preview

```bash
bundle install
bundle exec jekyll serve
```

Then open `http://localhost:4000`.

## Updating publications

Edit only `_data/publications.yml`. Both publication lists on the homepage are
generated from this file; there is no separate author file or paper numbering.

Each paper needs a `category` (`preprint` or `article`), `title`, `year`, `status`,
and the complete `authors` list, including M. Fritz, in publication order. Store
each author as `Family name, Initials`; the page displays initials first. This
also keeps compound surnames such as `Di Primio` and `ten Eikelder` intact.

```yaml
- category: article
  title: Example paper
  authors:
  - Brunk, A.
  - Fritz, M.
  year: 2026
  status: To appear
  venue: Example journal
  journal: https://example.org/journal
```

Within each category, papers are sorted automatically by **year, newest first**,
then alphabetically by the full author list (surname first), then by title.
The order of records in the YAML file does not matter. Keep the authors within
each record in their published order.

Use the publication year for articles and the preprint year for preprints. For
an accepted paper awaiting publication, use its acceptance year until the final
publication year is known. Move it to `category: article`, set `status: To appear`,
and add its `venue` and available `journal` or `doi` link. The status is displayed
alongside the year. Set `status: Published` once published.

Optional links are `doi`, `journal`, `arxiv`, and `preprint` (for other hosts).
An optional descriptive `id` provides a stable `#pub-<id>` link for research
figures; otherwise the anchor is generated from the title. Keep existing IDs
when changing a title. Images belong in the research section, not paper records.

## Page-specific mathematics

MathJax is loaded only when a page opts in:

```yaml
mathjax: true
```

## Automated checks

GitHub Actions builds the site, validates generated HTML and internal links,
runs WCAG 2 AA accessibility checks, and checks external links. Dependabot
checks Ruby gems and GitHub Actions monthly.

Publication data, ordering, accepted-paper status, and research links are checked
with `bundle exec ruby test/publications_test.rb` after building the site.

## Image optimization

Research images are lazy-loaded. The publication lists are text-only.
