require './anti_captcha'
require 'watir'
require 'csv'

## application
begin
  puts '------------start--------'

  WEB_CAPTCHA_URL = "https://www.paypal.com/signin"
  # get website key
  # iframe_captcha = browser.iframe(name: 'recaptcha')
  # src_captcha = iframe_captcha.attribute_value('src')
  # params = CGI.parse(URI.parse(src_captcha).query)
  # website_key = params['siteKey'][0]
  website_key = "6LepHQgUAAAAAFOcWWRUhSOX_LNu0USnf7Vg6SyA"
  puts 'website_key'
  puts website_key

  # anti captcha
  solution = AntiCaptcha.google_recaptcha(WEB_CAPTCHA_URL, website_key)

  # set captcha response

  # task
  # textarea = iframe_captcha.textarea(id: 'g-recaptcha-resp  onse')
  # browser.execute_script("return arguments[0].innerHTML = '#{solution['gRecaptchaResponse']}';", textarea) unless solution.nil?
  puts "submit"
  # browser.form(action: '/auth/validatecaptcha').submit
  puts "done"
        
end

