#connect
require 'net/http'
require 'uri'
require 'timeout'
require 'json'

begin

	#lets just keep it simple and connect to my github acount and grab my repos
	uri = URI("https://api.github.com/users/gregdangelo/repos")

	#so from all I've read I should be verifying the SSL cert due to a quirk with Net:HTTP... that being said I'm not too worried in this case since I won't be passing any info that you can't get straight from github.com
	Net::HTTP.start(uri.host,uri.port	, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
		request = Net::HTTP::Get.new uri.request_uri
		
		response = http.request request
		if response.code == "200"
			data = JSON.parse response.body
			data.each {|repo| puts "#{repo['name']} #{repo['forks']}:#{repo['watchers']} #{repo['pushed_at']}" }
		end
		
	end
#these 2 time outs are supposed to work... though I haven't tested them yet so I don't really know.  I admit there a straight copy and paste from a stackoverflow answer
rescue Timeout::Error => exc
    puts "ERROR: #{exc.message}"
rescue Errno::ETIMEDOUT => exc
    puts "ERROR: #{exc.message}"
#I tend to get these next 3 accidentally as I learn Ruby; helps me figure out why I messed up
rescue NameError => er
	puts "ummm thata not the right name yo"
	puts er
	puts
	puts er.backtrace
	puts	
rescue TypeError => er
	puts "oopsie daisy!"
	puts er
	puts
	puts er.backtrace
	puts
rescue => er
	puts er
	puts
	puts er.backtrace
	puts
end
#resources: http://www.rubyinside.com/nethttp-cheat-sheet-2940.html <-- some good stuff here