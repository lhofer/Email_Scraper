#Email Scraper
#####Leila Hofer

##About
This program takes in a domain name and searches all pages reachable from links on the home page for email addresses conatined on those pages. (Built in Ruby with Capybara/Poltergeist).

###Requirements
1. ruby (download instructions at https://www.ruby-lang.org/en/documentation/installation/)
2. Capybara: $ gem install capybara
3. Poltergeist: $ gem install poltergeist
4. Phantomjs: $ sudo apt-get install phantomjs

##Usage
$ ruby find_email_addresses.rb https://www.example.com

##Known Bugs
Error handleing on invalid URL/URI not always able to generate exception, leading to premature termination of program.