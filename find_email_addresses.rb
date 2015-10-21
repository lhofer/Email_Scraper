require 'capybara/poltergeist'
require 'open-uri'

#---- OPEN PAGE ENSURE VALID URL ---#
def open_page(session, url)
	# URI error checks
	begin
		res = Net::HTTP.get_response(URI.parse(url))
	rescue URI::InvalidURIError => error
		puts "Bad URI"
		return
	end
	# visit page
	session.visit(url)
	#return session
	session
end

#----PUSH FORMATTED LINK TO LINKS ARRAY---#
def push_href(link, links)
	# ensure href exists
	if (!link[:href].to_s.empty?)
		# ensure absolute path specified
		if (link[:href].scan(/http/).length != 1)
			links << ARGV[0] + link[:href]
		else
			links << link[:href]
		end
	end
end

#----PUSH FORMATTED EMAIL TO EMAILS ARRAY---#
def push_emails(element, emails)
	# look through text for emails
    string = element.text
    string = string.split
    string.each { |str|
	if ((str.include? '@') && (str.include? '.'))
		emails << str
	end
    }
    # look through hrefs for emails hidden behind click
    link = element[:href]		
	if ((link.to_s.include? '@') && (link.to_s.include? '.'))
		link = link.split('mailto:')
		if !link[1].to_s.empty?
			emails << link[1]
		end
	end

end

#----LOOK THROUGH COMMON TAGS TO FIND CSS ELEMENT---#
def find_css(session, array, switch)
	common_tags = ['a','div','p','span']

	# find links or emails in common tags
	common_tags.each { |tag|
		session.all(tag).each { |element|
			case switch
			# if looking for links
			when 1
				values = push_href(element, array)
			# if looking for emails
			when 2
				values = push_emails(element, array)
			else
				return 1
			end
		}
	}
end

#----MAIN---#
# check usage
if ARGV.length != 1
	puts("usage: ruby jana.rb http://www.example.com")
	exit
end

# configure Poltergeist to not blow up on js errors
Capybara.register_driver :poltergeist do |app|
	Capybara::Poltergeist::Driver.new(app, js_errors:false)
end

# configure Capybara settings with Poltergeist
Capybara.default_driver = :poltergeist

# start session and open page
puts("opening page...")
session = Capybara.current_session
# URL error checks
if (!ARGV[0].include? 'http')
	ARGV[0] = 'http://' + ARGV[0]
end
open_page(session, ARGV[0])

links = []
emails = []

#retrieve links and emails from home page
find_css(session, links, 1)
find_css(session, emails, 2)

# command line output
puts('pages visited of ' + (links.length + 1).to_s + ' total pages: ')
count = 1
print count
print ' '

# visit each page found from home page
links.each{ |link|
	# command line output
	count+=1
	print count
	print ' '

	# visit page and retrieve emails
	#session.visit(link)
	open_page(session, link)
	find_css(session, emails, 2)
}

# command line output
puts ''
puts '-----EMAILS RETRIEVED-------'
puts emails.uniq


