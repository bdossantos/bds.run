require 'html-proofer'
require 'image_optim'
require 'English'

LIBS_DIR = '_libs'
BUILD_DIR = '_build'
HTML_COMPRESSOR = `which htmlcompressor`.chomp
YUI_COMPRESSOR = `which yuicompressor`.chomp
BOWER = `which bower`.chomp
WGET = `which wget`.chomp
JEKYLL_ENV = ENV['JEKYLL_ENV'] || 'development'

desc 'Jekyll build'
task :jekyll_build do
  puts '--> Jekyll build'
  system "rm -rf #{BUILD_DIR}"
  config = File.exist?("_config_#{JEKYLL_ENV}.yml") ? ",_config_#{JEKYLL_ENV}.yml" : nil
  system "jekyll build -d #{BUILD_DIR} --config _config.yml#{config}"
end

desc 'Bower install'
task :bower_install do
  puts '--> Grab front-end packages with Bower'
  system "#{BOWER} install"
end

desc 'Minify all html'
task :minify_html do
  puts '--> Minifying html'
  system "find #{BUILD_DIR} -type f -name '*.html' " \
    "| xargs -I '%' -P 4 -n 1 #{HTML_COMPRESSOR} --remove-intertag-spaces " \
    "--compress-css --compress-js --js-compressor yui '%' -o '%'"
end

desc 'Gzip'
task :gzip, [:ext] => [:gzip_all] do |_t, args|
  puts "--> GZipping '#{args.ext}'"
  system "find #{BUILD_DIR} -type f -name '*.#{args.ext}' -print0 | " \
         "xargs -0 -I % -P 4 -n 1 sh -c 'gzip -9 < % > %.gz'"
end

desc 'GZip All'
task :gzip_all do
  Rake::Task[:gzip].execute('html')
  Rake::Task[:gzip].execute('css')
  Rake::Task[:gzip].execute('js')
end

desc 'Image optimization'
task :image_optimization do
  puts '--> Optimize images'
  image_optim = ImageOptim.new(pngout: false, svgo: false)
  image_optim.optimize_images!(Dir['**/*.png', '**/*.jpg']) do |u, o|
    puts "#{u} => #{o}" if o
  end
end

desc 'Test for 404s'
task :check_html do
  puts '--> Check for broken links'
  HTMLProofer.check_directory(
    BUILD_DIR,
    {
      ext: '.html',
      parallel: { in_processes: 4 },
      url_ignore: ['#', '/twitter.com/', '/disqus.com/'],
      validate_html: false,
      disable_external: true
    }
  ).run
end

desc 'Fix files permissions'
task :fix_files_permissions do
  puts '--> Fix files permissions'
  system "find #{BUILD_DIR} -type f | xargs -n 1 -P 4 chmod 644"
  system "find #{BUILD_DIR} -type d | xargs -n 1 -P 4 chmod 755"
end

desc 'Full build task'
task :build do
  puts '--> Start build'
  Rake::Task['bower_install'].invoke
  Rake::Task['jekyll_build'].invoke
  Rake::Task['minify_html'].invoke
  Rake::Task['gzip_all'].invoke
  Rake::Task['image_optimization'].invoke
  Rake::Task['fix_files_permissions'].invoke
  Rake::Task['check_html'].invoke
  puts '--> End'
end

desc 'Clean activities CSV'
task :clean_activites_csv do
  ACTIVITIES = './_data/activities/'

  # Clean whitespaces
  system "find #{ACTIVITIES} -type f -name '*.csv' | \
          xargs -n 1 -P 4 sed -i -e 's/^[ \t]*//' -e 's/[ \t]*$//'"

  # Clean last blank line
  system "find #{ACTIVITIES} -type f -name '*.csv' | \
          xargs -n 1 -P 4 sed -i '/^ *$/d'"

  # Clean useless line
  system "find #{ACTIVITIES} -type f -name '*.csv' | \
          xargs -n 1 -P 4 sed -i '/Activities by bdossantos/d'"
end
