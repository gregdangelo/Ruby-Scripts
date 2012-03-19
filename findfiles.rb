#find files in folder
src = 'C:/www/Ruby-Scripts/js'
dest = 'C:/www/Ruby-Scripts/dest'
puts "Source Folder: #{src}"
puts "Destination Folder: #{dest}"

#Dir.foreach(src) {
#puts Dir.getwd
Dir.chdir(src)
#puts Dir.getwd

#Just a test to grab our components
#Dir['*.js'].each { |filenames| puts filenames }

components = Dir['*.js']; 
#File.open(File.join(dest, 'test.js'), 'w') do |f|
#	f.puts components.map { |component|
#		File.read File.join(src, "#{component}")
#		#Let the world know what files we are combining
#		#puts "Adding component #{component}"
#	}
#end

def _combine(files,source,destination)
	if files.length < 1
		raise "must have at least one file"
	else
		File.open(destination, 'w') do |f|
			f.puts files.map { |file|
				File.read File.join(source, "#{file}")
			}
		end
	end
end
def _find(source,extension)
	Dir.chdir(source)
	Dir["*.#{extension}"]
end

def _find_combine(ext,src,dest)
	components = _find(src,ext)
	if components.length > 0 
		puts "Number of files in #{src} :#{components.length}"
		_combine components, src, dest
	else
		raise "No files to combine"
	end
end

begin
	#destination file
	destination = File.join(dest, 'test.js')

	_find_combine 'js',src,destination

	#should through an exception
	_find_combine 'css',src,destination
rescue RuntimeError => ex
	puts "ok folks we saved our bacon now"
	puts "#{ex.class}: #{ex.message}"

rescue => ex
	puts "ok folks we REALLY saved our bacon now"
	puts "#{ex.class}: #{ex.message}"

end