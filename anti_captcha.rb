require 'rest-client'

class AntiCaptcha
  CONFIG = {
    CLIENT_KEY: '7e26657ae100e2fd4b8757274366b33d',
    CREATE_TASK_URL: 'https://api.anti-captcha.com/createTask',
    GET_TASK_RESULT_URL: 'https://api.anti-captcha.com/getTaskResult',
    HEADER: {
      'Content-Type': 'application/json',
      Accept: 'application/json'
    }
  }.freeze

  RESPONSE_STATUS = {
    PROCESSING: 'processing',
    READY: 'ready'
  }.freeze

  def self.image_captcha(image_base64)
    # payload initial
    payload = JSON.generate(
      'clientKey': CONFIG[:CLIENT_KEY],
      'task': {
        'type': 'ImageToTextTask',
        'body': image_base64,
        'phrase': false,
        'case': false,
        'numeric': false,
        'math': 0,
        'minLength': 0,
        'maxLength': 0
      }
    )

    # request api
    task = JSON.parse(RestClient.post(CONFIG[:CREATE_TASK_URL], payload, CONFIG[:HEADER]))

    # log task
    puts task

    puts '=====>: (Captcha)Image Captcha task is sent, will wait for the result...'
    sleep(5)

    # call func for get task result
    process_task(task)
  end

  def self.google_recaptcha(website_url, website_key)
    # payload initial
    payload = JSON.generate(
      'clientKey': CONFIG[:CLIENT_KEY],
      'task': {
        'type': 'NoCaptchaTaskProxyless',
        'websiteURL': website_url,
        'websiteKey': website_key
      }
    )

    # request api
    task = JSON.parse(
      RestClient.post(CONFIG[:CREATE_TASK_URL], payload, CONFIG[:HEADER])
    )

    # log task
    puts "=====>: (Captcha)Task: #{task}"

    puts '=====>: (Captcha)Google Recaptcha task is sent, will wait for the result...'
    sleep(5)

    # call func for get task result
    process_task(task)
  end

  def self.process_task(task)
    # return when error
    if task['errorId'] != 0
      begin
        puts "=====>: (Captcha)Error occurred: #{task['errorDescription']}"
        return nil
      end
    end

    # initial payload
    payload = JSON.generate(
      'clientKey': CONFIG[:CLIENT_KEY],
      'taskId': task['taskId']
    )

    response = nil

    loop do
      response = JSON.parse(
        RestClient.post(CONFIG[:GET_TASK_RESULT_URL], payload, CONFIG[:HEADER])
      )

      puts response.inspect

      break if response['status'] == RESPONSE_STATUS[:READY]

      puts '=====>: (Captcha)Not done yet, waiting...'
      sleep(2)
    end

    if response.nil? || response['solution'].nil?
      begin
        puts '=====>: (Captcha)Unknown error occurred...'
        puts "=====>: (Captcha)Response dump:#{response}"
        return nil
      end
    else
      begin
        puts "=====>: (Captcha)The answer is '" + response['solution'].to_s + "'"
        return response['solution']
      end
    end
  end
end
