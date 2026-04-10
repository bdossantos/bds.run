# bds.run

[![CI](https://github.com/bdossantos/bds.run/actions/workflows/cd.yml/badge.svg)](https://github.com/bdossantos/bds.run/actions/workflows/cd.yml)

Source code for [bds.run](https://bds.run), a personal weblog and running stats
site by Benjamin Dos Santos. It is a static website powered by
[Jekyll](https://jekyllrb.com/).

## Prerequisites

- [Ruby](https://www.ruby-lang.org/) 3.4
- [Bundler](https://bundler.io/)
- [Node.js](https://nodejs.org/) and npm

## Development

```bash
gem install bundler
bundle install
npm install
bundle exec jekyll serve -w
open http://127.0.0.1:4000
```

## Build

```bash
npm install
bundle exec rake build
```

For a production build:

```bash
JEKYLL_ENV=production bundle exec rake build
```

The build output goes to `_build/`.

### Rake tasks

| Task                         | Description                              |
| ---------------------------- | ---------------------------------------- |
| `rake jekyll_build`          | Build the site with Jekyll               |
| `rake minify_html`           | Minify all HTML files                    |
| `rake gzip_all`              | GZip HTML, CSS, and JS files             |
| `rake check_html`            | Check for broken internal links          |
| `rake build`                 | Full build (all of the above)            |
| `rake generate_activity_summary` | Regenerate activity summary from CSV |

## Testing

```bash
ruby _scripts/test_activity_summary.rb
```

## Project structure

```
_posts/      Blog posts (Markdown)
_layouts/    Jekyll HTML layout templates
_includes/   Reusable Jekyll HTML partials
_data/       Data files (activity CSVs, race GeoJSON, etc.)
_scripts/    Ruby helper scripts (activity summary generation)
assets/      Static assets (CSS, JS, images)
_config.yml  Main Jekyll configuration
Rakefile     Build automation tasks
```

## Deployment

The site is automatically built and deployed to GitHub Pages via
[GitHub Actions](.github/workflows/cd.yml) on every push to `master`.

**Please, don't deploy this as is.** It's a personal weblog; the code has been
open-sourced for educational purposes only.

## License

Code, templates, CSS & JS are released under the terms of the
[WTFPL](http://www.wtfpl.net/).

**Important note: You can freely reuse parts of the project code, but you can't
republish the blog with its contents as is publicly.**
