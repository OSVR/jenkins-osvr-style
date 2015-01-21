require 'rake/clean'

task default: %w[dev]

file_stem = 'jenkins-osvr-style'
out_dir = '_site/'

generated_extensions = %w[css css.map]
generated_extensions.each do |ext|
  CLEAN << "#{file_stem}.#{ext}"
  CLEAN << "#{out_dir}#{file_stem}.#{ext}"
end

output_extensions = %w[css js]

desc "Force a Sass rebuild"
task :force_sass do
  touch "#{file_stem}.scss"
end

desc "Build for local development"
task :dev => :force_sass do
  pids = [
    spawn("sass --style expanded --watch #{file_stem}.scss:#{file_stem}.css"),
    spawn("ruby -run -ehttpd . -p8000")
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end

desc "Build for production"
task :production => output_extensions.map{|ext| "#{out_dir}#{file_stem}.#{ext}"}

directory out_dir do |t|
  mkdir_p t.name
end

file "#{out_dir}#{file_stem}.css" => ["#{file_stem}.scss", out_dir] do |t|
  system "sass --style compressed #{t.prerequisites[0]}:#{t.name}"
end

file "#{out_dir}#{file_stem}.js" => ["#{file_stem}.js", out_dir] do |t|
  cp t.prerequisites[0], t.name
end
