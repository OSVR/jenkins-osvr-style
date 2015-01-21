require 'rake/clean'

task default: %w[production]

file_stem = 'jenkins-osvr-style'
out_dir = '_site/'

generated_extensions = %w[css css.map]
generated_extensions.each do |ext|
  CLEAN << "#{file_stem}.#{ext}"
  CLEAN << "#{out_dir}#{file_stem}.#{ext}"
end
CLEAN << "#{out_dir}"

output_extensions = %w[css js]

desc "Install the required gems locally with Bundler"
task :bundle do
  sh "bundler install --path vendor/bundle"
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

desc "Build for production"
task :production => ([:force_sass, :bundle].concat output_extensions.map{|ext| "#{out_dir}#{file_stem}.#{ext}"})

desc "Publish to GitHub pages"
task :publish => [:production] do
  task("publishing:publish").invoke("_site")
end

## Actual compilation tasks
directory out_dir

file "#{out_dir}#{file_stem}.css" => ["#{file_stem}.scss", out_dir, :bundle] do |t|
  sh sass_cmd :task=>t, :style=>:compressed
end

file "#{out_dir}#{file_stem}.js" => ["#{file_stem}.js", out_dir] do |t|
  cp t.prerequisites[0], t.name
end
