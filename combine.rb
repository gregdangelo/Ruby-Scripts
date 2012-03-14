require 'rake/packagetask'
task :default => [:clean, :concat, :dist]


PROJ_ROOT     = File.expand_path(File.dirname(__FILE__))
PROJ_SRC_DIR  = File.join(PROJ_ROOT, 'src')
PROJ_DIST_DIR = File.join(PROJ_ROOT, 'dist')
PROJ_COMPONENTS = [
  'polyfill',
  'zepto',
  'event',
  'detect',
  'fx',
  # 'fx_methods',
  'ajax',
  'form',
  # 'assets',
  # 'data',
  'touch',
  # 'gesture'
]


desc "Concatenate source files to build zepto.js"
task :concat, [:addons] => :whitespace do |task, args|
  # colon-separated arguments such as `concat[foo:bar:-baz]` specify
  # which components to add or exclude, depending on if it starts with "-"
  add, exclude = args[:addons].to_s.split(':').partition {|c| c !~ /^-/ }
  exclude.each {|c| c.sub!('-', '') }
  components = (PROJ_COMPONENTS | add) - exclude

  unless components == PROJ_COMPONENTS
    puts "Building zepto.js by including: #{components.join(', ')}"
  end

  File.open(File.join(PROJ_DIST_DIR, 'zepto.js'), 'w') do |f|
    f.puts components.map { |component|
      File.read File.join(PROJ_SRC_DIR, "#{component}.js")
    }
  end
end
