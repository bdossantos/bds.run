# A fat image for a tiny blog ;)

FROM ruby:2.1.5-onbuild
MAINTAINER benjamin.dossantos@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV TIMEZONE Europe/Paris
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8

# locales
RUN apt-get update
RUN apt-get install -y apt-utils locales gzip
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

# Dotdeb
WORKDIR /tmp
RUN echo 'deb http://packages.dotdeb.org wheezy all' > \
  /etc/apt/sources.list.d/dotdeb.list
RUN echo 'deb-src http://packages.dotdeb.org wheezy all' >> \
  /etc/apt/sources.list.d/dotdeb.list
RUN wget --quiet http://www.dotdeb.org/dotdeb.gpg
RUN apt-key add dotdeb.gpg && apt-get update

# Nginx
RUN apt-get -y install nginx-light
RUN git clone -q --depth 1 https://github.com/h5bp/server-configs-nginx.git \
  /opt/server-configs-nginx
RUN cp -f /opt/server-configs-nginx/nginx.conf /etc/nginx/nginx.conf
RUN sed -i 's/user www www/user www-data www-data/' /etc/nginx/nginx.conf
RUN echo 'daemon off;' >> /etc/nginx/nginx.conf
# avoid sed to replace relative access/error logs path in h5bp default conf
RUN mkdir /usr/share/nginx/logs
RUN mkdir /etc/nginx/h5bp && cp -a /opt/server-configs-nginx/h5bp/. /etc/nginx/h5bp/
ADD _config/etc/nginx/sites-enabled/runner.sh \
  /etc/nginx/sites-enabled/runner.sh
RUN ln -sf /dev/stdout /var/log/nginx/runner.sh.access.log && \
  ln -sf /dev/stderr /var/log/nginx/runner.sh.error.log

# Node.js
WORKDIR /usr/local/src
RUN wget --quiet http://nodejs.org/dist/v0.10.36/node-v0.10.36-linux-x64.tar.gz
RUN tar -zxf node-v0.10.36-linux-x64.tar.gz
WORKDIR /usr/local/bin
RUN ln -s /usr/local/src/node-v0.10.36-linux-x64/bin/node && \
  ln -s /usr/local/src/node-v0.10.36-linux-x64/bin/npm
RUN npm install --silent -g bower

# Image optim
RUN apt-get install -y advancecomp gifsicle jhead jpegoptim libjpeg-progs \
  optipng pngcrush pngquant

# Htmlcompressor, yuicompressor etc
WORKDIR /usr/local/src
RUN apt-get install -y default-jre-headless
RUN wget --quiet \
  https://htmlcompressor.googlecode.com/files/htmlcompressor-1.5.3.jar
RUN wget --quiet \
  https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar
ADD _config/usr/local/bin/htmlcompressor /usr/local/bin/htmlcompressor
ADD _config/usr/local/bin/yuicompressor /usr/local/bin/yuicompressor

# Build teh website
WORKDIR /usr/src/app
RUN echo 'gem: --no-rdoc --no-ri' > ~/.gemrc
RUN bundle install && bower --allow-root install
RUN rake jekyll_build minify_html gzip_all image_optimization \
  fix_files_permissions

# Clean
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# Serve
WORKDIR /etc/nginx
EXPOSE 80 443
ENTRYPOINT /usr/sbin/nginx
