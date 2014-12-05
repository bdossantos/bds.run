# runner.sh

It's the whole code of my [weblog][1] and Running plans, open sourced.
Basicly it's a simple static website powered by [Jekyll][2].

## Installation

```
gem install bundler
bundle install
jekyll serve -w
open http://127.0.0.1:4000
```

## Deploy

**Please, don't deploy this as is.**

It's my personnal weblog, the code has been opensourced for educational purpose
only.

```bash
brew install htmlcompressor yuicompressor s3cmd nodejs
npm install bower
rake deploy
```

## Licence

Code, templates, CSS & JS is released under the terms of the
[Do What The Fuck You Want To Public License][3].

**Important note: You can freely reuse parts of the project code, but you can't
republish the blog with this contents as is publicly.**

[1]: http://runner.sh/
[2]: http://jekyllrb.com/
[3]: http://sam.zoy.org/wtfpl/
