# bds.run

[![Build Status](https://travis-ci.org/bdossantos/bds.run.svg)](https://travis-ci.org/bdossantos/bds.run)

It's the whole code of my [weblog][1] and Running plans, open sourced.
Basically it's a simple static website powered by [Jekyll][2].

## Features

- **Training Log**: Monthly training posts with distance, elevation, and time tracking
- **Statistics Page**: Automated aggregation of training data with:
  - Total training sessions, distance, elevation, and time
  - Average pace and performance metrics
  - Monthly breakdown with detailed statistics
  - Activity type distribution

## Installation

```
gem install bundler
bundle install
jekyll serve -w
open http://127.0.0.1:4000
```

## Content Structure

### Training Posts

Monthly training posts should be placed in `_posts/YYYY/` with the format:
`YYYY-MM-DD-entrainement-MONTH-YYYY.md`

Each training post requires the following frontmatter:

```yaml
---
layout: post
title: Entrainement [month] [year]
description: Bilan sportif du mois de [month] [year]
category: entrainement
distance: XXX.X km
elevation: XXXX m
time: 'HH:MM h:m'
---
```

### Statistics Page

The statistics page (`/statistics.html`) automatically aggregates data from all training posts with `category: entrainement` and displays:

- **Total metrics**: Sessions, distance, elevation, and time
- **Averages**: Per-session metrics and overall pace
- **Monthly breakdown**: Detailed table with individual session data
- **Activity distribution**: Breakdown by activity type

The page updates automatically when new training posts are added.
```

## Deploy

**Please, don't deploy this as is.**

It's my personnal weblog, the code has been opensourced for educational purpose
only.

```bash
brew install htmlcompressor yuicompressor s3cmd nodejs \
  advancecomp gifsicle jhead jpegoptim jpeg \
  optipng pngcrush pngquant
npm install
rake deploy
```

## Licence

Code, templates, CSS & JS is released under the terms of the
[Do What The Fuck You Want To Public License][3].

**Important note: You can freely reuse parts of the project code, but you can't
republish the blog with this contents as is publicly.**

[1]: https://bds.run/
[2]: http://jekyllrb.com/
[3]: http://sam.zoy.org/wtfpl/
