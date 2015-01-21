SASS_CMD = 'bundler exec sass'

def sass_cmd(options = {})
  t = options.delete :task
  if t
    input = t.prerequisites[0]
    output = t.name
  end

  stem = options.delete :stem
  if stem
    input = "#{stem}.scss"
    output = "#{stem}.css"
  end

  input = options.delete(:input) if options.has_key? :input
  output = options.delete(:output) if options.has_key? :output

  args = []

  args << options.delete(:flags).map {|flag| "--#{flag.to_s}"} if options.has_key? :flags
  args << options.map do |key, val|
    ["--#{key.to_s}", val.to_s]
  end

  cmd = "#{SASS_CMD} #{args.join " "} #{input}:#{output}"
  puts cmd
  cmd
end
