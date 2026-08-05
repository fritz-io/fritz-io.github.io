# marvinfritz.de

Academic website of Marvin Fritz, built with Jekyll and the Minimal Mistakes remote theme.

## Local preview

```bash
bundle install
bundle exec jekyll serve
```

Then open `http://localhost:4000`.

## Updating publications

Edit `_data/publications.yml`. The publications page and the selected-publication
section on the homepage are generated from that file.

Each publication needs a unique `number`, a `category` (`preprint` or `article`),
a title, and any available links. Set `selected: true` and add a short `summary`
to feature an item on the homepage.

## Page-specific mathematics

MathJax is loaded only when a page opts in:

```yaml
mathjax: true
```

## Automated checks

GitHub Actions builds the site, validates generated HTML and internal links,
runs WCAG 2 AA accessibility checks, and checks external links. Dependabot
checks Ruby gems and GitHub Actions monthly.

## Image optimization

The homepage uses `assets/images/research.webp`, a resized WebP replacement for the former 5.8 MB PNG. Publication images are lazy-loaded.
