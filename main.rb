require './anti_captcha'
require 'watir'
require 'csv'

WEB_URL = "https://www.paypal.com/signin" 
SHORT_TIME_DELAY = 2
EMAIL = "lamnn"
file_path = 'data.csv'
count = 0


## import data from csv
list_email = Array.new
list_password = Array.new

CSV.foreach(file_path) do |row|
    list_email << row[0]
    list_password << row[1]
end

count = list_email.length()


## application
begin

    for i in 1..count
        puts ".... at "
        browser = Watir::Browser.new:chrome
    
        puts "....open "
        browser.goto(WEB_URL)
        
        sleep(SHORT_TIME_DELAY)
    
        puts "write email "
        browser.text_field(id: 'email').set(list_email[i])
    
        puts "click next login "
        browser.button(text: 'Next').click
        
        sleep(SHORT_TIME_DELAY)
    
        puts "write password "
        browser.text_field(id: 'password').set(list_password[i])
        
        puts "click next password"
        browser.button(text: 'Log In').click

        # unless browser.text_field(id: 'recaptcha-token').nil?
        #     sleep(50)

        # end


        puts "-----check iframe"

        if browser.iframe(name: 'recaptcha').exists?
            puts "-----in iframe"
            if browser.iframe(name: 'recaptcha').iframe.exists?
                puts "in  1"
                if browser.iframe(name: 'recaptcha').iframe.input(id: 'recaptcha-token').exists?
                    puts "in  2"
                    puts 'anti google captcha'

                    website_key = browser.iframe(name: 'recaptcha').iframe.input(id: 'recaptcha-token').value
                    solution = AntiCaptcha.google_recaptcha(WEB_URL, website_key)
                    textarea = browser.iframe(name: 'recaptcha').iframe.textarea(id: 'g-recaptcha-response')
                    browser.execute_script("return arguments[0].innerHTML = '#{solution['gRecaptchaResponse']}';", textarea) unless solution.nil?

                    puts solution
                    sleep(40)

                end
            end
        end


        puts '------------------------------------------'
        puts "....finish "
        sleep(SHORT_TIME_DELAY)
        browser.close
    end
end

