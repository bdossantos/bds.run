require 'juicer'

LIBS_DIR = '_libs'
BUILD_DIR = '_build'
HTML_COMPRESSOR=`which htmlcompressor`.chomp
YUI_COMPRESSOR=`which yuicompressor`.chomp
BUCKET='s3://runner.sh'
RASPBERRY='pi@192.168.0.252:/srv/http/runner.sh'

desc 'Jekyll build'
task :jekyll_build do
  puts '# Jekyll build'
  system "find #{BUILD_DIR} | xargs chmod 755"
  system "rm -rf #{BUILD_DIR}"
  system "jekyll build -d #{BUILD_DIR}"
end

desc 'Notify Google of the new sitemap'
task :sitemap do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Google about our sitemap'
    Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' +
    URI.escape('http://runner.sh/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found.'
  end
end

desc 'Merge stylesheets'
task :minify_css do
  puts '# Merge all css'
  system "juicer merge --force #{BUILD_DIR}/css/main.css -o " +
         "#{BUILD_DIR}/css/main.css"
end

desc 'Merges JavaScripts'
task :minify_js do
  puts '# Merge JS'
  system "juicer merge -i --force #{BUILD_DIR}/js/common.js"
end

desc 'Minify all html'
task :minify_html do
  puts '# Minifying all html'
  system "find #{BUILD_DIR} -type f -name '*.html' " +
    "| xargs -I '%' -P 4 -n 1 #{HTML_COMPRESSOR} --remove-intertag-spaces " +
    "--compress-css --compress-js --js-compressor yui '%' -o '%'"
end

desc 'Minify All'
task :minify => [:minify_css, :minify_js, :inline_css, :minify_html]

desc 'Inlinify CSS'
task :inline_css do
  minified_css = File.open("#{BUILD_DIR}/css/main.css", 'r').read

  Dir.glob("#{BUILD_DIR}/**/*.html") do |name|
    File.open(name, 'r+') do |f|
      new_file = f.read.sub \
        /<link rel="stylesheet" href="\/css\/main.css\">/,
        "<style>#{minified_css}</style>"

      f.truncate 0
      f.write new_file
    end
  end
end

desc "Gzip"
task :gzip, [:ext] => [:gzip_all] do |t, args|
  puts "GZipping '#{args.ext}'"
  system "find #{BUILD_DIR} -type f -name '*.#{args.ext}' -print0 | " +
         "xargs -0 -I % -P 4 -n 1 sh -c 'gzip -9 < % > %.gz'"
end

desc 'GZip All'
task :gzip_all do
  Rake::Task[:gzip].execute('html')
  Rake::Task[:gzip].execute('css')
  Rake::Task[:gzip].execute('js')
end

desc 'upload to s3'
task :upload_to_s3 do
  puts 'Sync media files first + set cache expires'
  system "s3cmd sync \
      --no-preserve \
      --guess-mime-type \
      --acl-public \
      --exclude '*.*' \
      --include '*.png' \
      --include '*.jpg' \
      --include '*.ico' \
      --add-header='Expires: Sat, 20 Nov 2020 18:46:39 GMT' \
      --add-header='Cache-Control: max-age=6048000' \
      #{BUILD_DIR}/ \
      #{BUCKET}"

  puts 'Sync Javascript and CSS assets next (Cache: expire in 1 week)'
  system "s3cmd sync \
      --no-preserve \
      --guess-mime-type \
      --acl-public \
      --exclude '*.*' \
      --include '*.css' \
      --include '*.js' \
      --add-header='Cache-Control: max-age=604800' \
      --add-header='Vary: Accept-Encoding' \
      #{BUILD_DIR}/ \
      #{BUCKET}"

  puts 'Sync Gzipped files'
  system "s3cmd sync \
      --no-preserve \
      --guess-mime-type \
      --acl-public \
      --exclude '*.*' \
      --include '*.gz' \
      --add-header='Cache-Control: max-age=604800' \
      --add-header='Content-Encoding: gzip' \
      #{BUILD_DIR}/ \
      #{BUCKET}"

  puts 'Sync everything else, but ignore the assets!'
  system "s3cmd sync \
      --no-preserve \
      --guess-mime-type \
      --acl-public \
      --exclude '*.*' \
      --exclude '.htaccess' \
      --include '*.html' \
      --add-header='Cache-Control: max-age=7200, must-revalidate' \
      --add-header='Vary: Accept-Encoding' \
      #{BUILD_DIR}/ \
      #{BUCKET}"

  puts 'Sync: remaining files & delete removed'
  system "s3cmd sync \
      --no-preserve \
      --acl-public \
      --delete-removed \
      #{BUILD_DIR}/ \
      #{BUCKET}"
end

desc 'Fix files permissions'
task :fix_files_permissions do
  puts '--> Fix files permissions'
  system "find #{BUILD_DIR} -type f | xargs chmod 444"
  system "find #{BUILD_DIR} -type d | xargs chmod 555"
end

desc 'Upload to Raspberry Pi'
task :upload_to_pi do
  puts '--> Upload to Raspberry Pi'
  system "rsync -zav --delete #{BUILD_DIR}/ #{RASPBERRY}/"
end

desc 'Full deployement task'
task :deploy do
  puts '--> Start Deploy'
  Rake::Task['jekyll_build'].invoke
  Rake::Task['minify'].invoke
  Rake::Task['gzip_all'].invoke
  Rake::Task['fix_files_permissions'].invoke
  Rake::Task['upload_to_s3'].invoke
  Rake::Task['upload_to_pi'].invoke
  puts '--> End'
end
