require 'watir'

WEB_URL = "https://www.paypal.com/vn/signin"
SHORT_TIME_DELAY = 2
EMAIL = "lamnn"

begin
    puts "....hello"
    browser = Watir::Browser.new:chrome

    puts "....open "
    browser.goto(WEB_URL)
    
    sleep(SHORT_TIME_DELAY)

    puts "write email "
    browser.text_field(id: 'email').set(EMAIL)

    puts "click dang nhap "
    browser.a(text: 'Next').click
    puts "....finish "

end