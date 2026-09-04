require 'fileutils'
require 'html-proofer'
require 'image_optim'
require 'English'

LIBS_DIR = '_libs'
BUILD_DIR = '_build'
NPM = ENV.fetch('NPM', 'npm')
JAMPACK = './node_modules/.bin/jampack'
JEKYLL_ENV = ENV['JEKYLL_ENV'] || 'development'

module BuildHelpers
  def run_command(command, **kwargs)
    system(*command, **kwargs) || raise("Command failed: #{command.join(' ')}")
  end

  def jekyll_config_files
    files = ['_config.yml']
    production_config = "_config_#{JEKYLL_ENV}.yml"
    files << production_config if File.exist?(production_config)
    files
  end
end

include BuildHelpers

desc 'Jekyll build'
task :jekyll_build do
  puts '--> Jekyll build'
  FileUtils.rm_rf(BUILD_DIR)

  run_command(['jekyll', 'build', '-d', BUILD_DIR, '--config', *jekyll_config_files])

  if JEKYLL_ENV == 'production'
    puts '--> Run jampack'
    run_command([JAMPACK, BUILD_DIR])
  end
end

desc 'npm install'
task :npm_install do
  puts '--> Grab front-end packages with npm'
  run_command([NPM, 'install'])
end

desc 'Minify all html'
task :minify_html do
  puts '--> Minifying html'
  system "find #{BUILD_DIR} -type f -name '*.html' " \
    "| xargs -I '%' -P 4 -n 1 node_modules/.bin/html-minifier " \
    '--collapse-whitespace --remove-comments --remove-optional-tags ' \
    '--remove-redundant-attributes --remove-script-type-attributes ' \
    '--remove-tag-whitespace --use-short-doctype --minify-css true ' \
    "--conservativeCollapse --minify-js true '%' -o '%'"
end

desc 'Gzip'
task :gzip, [:ext] do |_t, args|
  ext = args[:ext] || 'html'
  puts "--> GZipping '#{ext}'"
  system "find #{BUILD_DIR} -type f -name '*.#{ext}' -print0 | " \
         "xargs -0 -I % -P 4 -n 1 sh -c 'gzip -9 < % > %.gz'"
end

desc 'GZip All'
task :gzip_all do
  %w[html css js].each do |ext|
    Rake::Task[:gzip].invoke(ext)
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
  %i[npm_install jekyll_build minify_html gzip_all fix_files_permissions check_html].each do |task_name|
    Rake::Task[task_name].invoke
  end
  puts '--> End'
end

task :default => :build

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

desc 'Generate activity summary from CSV data'
task :generate_activity_summary do
  puts '--> Generating activity summary'
  system 'ruby _scripts/generate_activity_summary.rb' || exit(1)
end
