# require 'rubygems'
# require 'mechanize'
# require 'nokogiri'
#
#
# agent = Mechanize.new
#
# login = agent.get('https://app.10000ft.com/si')
# login_form = login.form
# puts login_form
# username_field = login_form.field_with(:name => "username")
# username_field = "winnie@mentallyfriendly.com"
# page = agent.submit login_form
#
# # Below opens URL requesting password and finds first field and fills in form then submits page.
#
# login = agent.get('https://app.10000ft.com/si')
# login_form = login.form
# password_field = login_form.field()
# password_field = "Herbelin2"
# page = agent.submit login_form
#
# # Below will print page showing information confirming that you have logged in.
#
# pp page
#
# send_event('google', text: page)





# agent.add_auth('https://app.10000ft.com/viewproject?id=1257828', 'winnie@mentallyfriendly.com', 'Herbelin2')
# page = agent.get('https://app.10000ft.com/viewproject?id=1257828').search(".//*[@id='mainCon']/div")
#
# print "*************** HELLO ***************"
# print page
#
#   send_event('google', text: page)


# page.links.each do |link|
#   puts link.text
# end

# /div[1]/div[1]/div/div/div[2]/div/div[2]/div[1]

# /div[1]/div/div/div[2]/div/div[2]/div[1]
