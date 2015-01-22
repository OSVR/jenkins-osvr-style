require 'rake/clean'

task default: %w[production]


file_stem = 'jenkins-osvr-style'
generated_extensions = %w[css]
OUT_DIR = '_site'
STATIC_DIR = 'static'

def output_for(fn)
  File.join OUT_DIR, fn
end

%w[css css.map].each do |ext|
  CLEAN << "#{file_stem}.#{ext}"
  CLEAN << output_for("#{file_stem}.#{ext}")
end
CLEAN << OUT_DIR

desc "Install the required gems locally with Bundler"
task :bundle do
  sh "bundle install --path vendor/bundle"
end

desc "Force a Sass rebuild"
task :force_sass do
  touch "#{file_stem}.scss"
end

desc "Build for local development"
task :dev => [:force_sass, :bundle] do
  sh sass_cmd :style=>:expanded,:stem=>file_stem
end

desc "Watch for changes and launch a web server for development"
task :watch => [:dev, :bundle] do
  pids = [
    spawn( sass_cmd :style=>:expanded, :flags=>[:watch], :stem=>file_stem),
    #spawn("ruby -run -ehttpd . -p80")
  ]
  cd '..' do
    pids << spawn("ruby -run -ehttpd . -p80")
  end

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end



production_files = generated_extensions.map{|ext| output_for "#{file_stem}.#{ext}"}

desc "Build for production"
task :production => ([:bundle].concat production_files)

desc "Publish to GitHub pages"
task :publish => [:force_sass, :production] do
  task("publishing:publish").invoke(OUT_DIR)
end

## Actual compilation tasks
directory OUT_DIR

file output_for("#{file_stem}.css") => ["#{file_stem}.scss", OUT_DIR, :bundle] do |t|
  sh sass_cmd :task=>t, :style=>:compressed, :sourcemap=>:none
end

## Copy static files
FileList.new("#{STATIC_DIR}/*").each do |item|
  target = item.sub STATIC_DIR, OUT_DIR
  CLEAN << target
  file target => [item, OUT_DIR] do |t|
    cp t.prerequisites[0], t.name
  end
  task :production => [target]

  dev_target = item.sub "#{STATIC_DIR}/", ''
  CLEAN << dev_target
  file dev_target => [item] do |t|
    cp t.prerequisites[0], t.name
  end
  task :dev => [dev_target]
end
