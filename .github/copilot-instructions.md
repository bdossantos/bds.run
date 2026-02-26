# GitHub Copilot Instructions

## Project Overview

This is the source code for [bds.run](https://bds.run), a personal weblog and running plans site by Benjamin Dos Santos. It is a static website powered by [Jekyll](https://jekyllrb.com/).

## Tech Stack

- **Static site generator**: Jekyll (Ruby)
- **Dependency management**: Bundler (`Gemfile`) for Ruby gems, npm (`package.json`) for Node.js packages
- **Build automation**: Rake (`Rakefile`)
- **CI/CD**: GitHub Actions (`.github/workflows/cd.yml`) deploying to GitHub Pages

## Key Directories and Files

- `_posts/` — Blog post content in Markdown
- `_layouts/` — Jekyll HTML layout templates
- `_includes/` — Reusable Jekyll HTML partials
- `_data/` — Data files (e.g., activity CSVs from Strava)
- `_scripts/` — Ruby helper scripts (e.g., generating activity summaries)
- `assets/` — Static assets (CSS, JS, images)
- `_config.yml` — Main Jekyll configuration
- `_config_production.yml` — Production-specific Jekyll overrides
- `Rakefile` — Build tasks: `jekyll_build`, `minify_html`, `gzip_all`, `check_html`, `build`

## Development

```bash
gem install bundler
bundle install
jekyll serve -w
open http://127.0.0.1:4000
```

## Build

```bash
npm install
bundle exec rake build            # full build (dev)
JEKYLL_ENV=production bundle exec rake build  # production build
```

## Conventions

- Posts are written in Markdown with YAML front matter
- Permalinks follow the pattern `/:year/:month/:day/:title.html`
- Ruby files use `frozen_string_literal: true`
- The build output goes to `_build/`
