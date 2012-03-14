#
# Minify
# (Eventual) Purpose
# Minify, compress, compile different types of files for production
# allow options to use a variety of different tools
#
#
require 'rake/packagetask'
task :default => [:clean, :concat, :dist]


#Minification functions
#Taken from Zepto.js Rakefile
PROJ_ROOT     = File.expand_path(File.dirname(__FILE__))

PROJ_SRC_DIR = File.join(PROJ_ROOT, 'dest')
PROJ_DIST_DIR = File.join(PROJ_ROOT, 'src')

def google_compiler(src, target)
  puts "Minifying #{src} with Google Closure Compiler..."
  `java -jar vendor/google-compiler/compiler.jar --js #{src} --summary_detail_level 3 --js_output_file #{target}`
  puts "done."
end

def yui_compressor(src, target)
  puts "Minifying #{src} with YUI Compressor..."
  `java -jar vendor/yuicompressor/yuicompressor-2.4.2.jar #{src} -o #{target}`
  puts "done."
end

#JSmin?
def jsmin_crockford(src, target)
  put "Minifying #{src} with Douglas Crockford's JSMIN..."
  `java -jar vendor/yuicompressor/yuicompressor-2.4.2.jar #{src} -o #{target}`
  puts "done."
end

#CSSmin ... it's Barry can something anyways
def barryvanolen(src, target)
  put "Minifying #{src} with Barry van Olen's CSSMIN..."
  `java -jar vendor/yuicompressor/yuicompressor-2.4.2.jar #{src} -o #{target}`
  puts "done."
end

def uglifyjs(src, target)
  begin
    require 'uglifier'
  rescue LoadError => e
    if verbose
      puts "\nYou'll need the 'uglifier' gem for minification. Just run:\n\n"
      puts "  $ gem install uglifier"
      puts "\nand you should be all set.\n\n"
      exit
    end
    return false
  end
  puts "Minifying #{src} with UglifyJS..."
  File.open(target, "w"){|f| f.puts Uglifier.new.compile(File.read(src))}
  puts "done."
end

def process_minified(src, target)
  cp target, File.join(PROJ_DIST_DIR,'temp.js')
  msize = File.size(File.join(PROJ_DIST_DIR,'temp.js'))
  `gzip -9 #{File.join(PROJ_DIST_DIR,'temp.js')}`

  osize = File.size(src)
  dsize = File.size(File.join(PROJ_DIST_DIR,'temp.js.gz'))
  rm_rf File.join(PROJ_DIST_DIR,'temp.js.gz')

  puts "Original version: %.3fk" % (osize/1024.0)
  puts "Minified: %.3fk" % (msize/1024.0)
  puts "Minified and gzipped: %.3fk, compression factor %.3f" % [dsize/1024.0, osize/dsize.to_f]
end

desc "Generates a minified version for distribution, using UglifyJS."
task :dist do
  src, target = File.join(PROJ_DIST_DIR,'zepto.js'), File.join(PROJ_DIST_DIR,'zepto.min.js')
  uglifyjs src, target
  process_minified src, target
end

desc "Generates a minified version for distribution using the Google Closure compiler."
task :googledist do
  src, target = File.join(PROJ_DIST_DIR,'zepto.js'), File.join(PROJ_DIST_DIR,'zepto.min.js')
  google_compiler src, target
  process_minified src, target
end

desc "Generates a minified version for distribution using the YUI compressor."
task :yuidist do
  src, target = File.join(PROJ_DIST_DIR,'zepto.js'), File.join(PROJ_DIST_DIR,'zepto.min.js')
  yui_compressor src, target
  process_minified src, target
end


src, target_uglify, target_google, target_yui = File.join(PROJ_SRC_DIR,'test.js'), File.join(PROJ_DIST_DIR,'zepto.uglify.js'), File.join(PROJ_DIST_DIR,'zepto.google.js'), File.join(PROJ_DIST_DIR,'zepto.yui.js')
puts "Source #{src}"
puts "Target #{target_uglify}"
uglifyjs src, target_uglify
#Need Java installed to run these...
#yui_compressor src, target_yui
#google_compiler src, target_google

