require 'net/http'
require 'meetup_date_generator'

class NotificationsController < ApplicationController

  def webhook
    # TELEGRAM ====> RAILS_BOT
    # input from telegram is a `Update` object
    begin
      input = JSON.parse(request.body.read, symbolize_names: true) || {}
      input_reply = { "status": 202, "message": "request accepted" }
      # logger.debug input
      # logger.debug " "
    rescue
      input_reply = { "status": 400, "message": "request malformed" }
      logger.error "error into input request malformed 400: #{request.body.read}"
    end

    # set locale
    I18n.locale = input[:message][:from][:language_code]
    # parse message
    output, output_method = parse(input)
    logger.info "==== output "
    logger.info JSON.pretty_generate(output)

    # TELEGRAM <==== RAILS_BOT
    # bot response to https://api.telegram.org/bot<token>/METHOD_NAME

    # WITH HTTPX
    # output_reply_raw = HTTPX.post("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/#{output_method}", json: output.to_json)
    # output_reply = output_reply_raw.to_s
    # logger.info "==== output_reply "
    # logger.info JSON.pretty_generate(JSON.parse(output_reply))

    # WITH NET/HTTP
    uri = URI("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/#{output_method}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/json"
    request.body = output.to_json
    response = https.request(request)

    logger.debug "==== response"
    logger.debug response.body


    ri = RequestInteraction.new
    ri[:chat_id] = input[:message][:chat][:id]
    ri[:telegram_date] = input[:message][:date]
    ri[:from_user] = input[:message][:from][:first_name]
    ri[:from_user_id] = input[:message][:from][:id]
    # ri[:from_ip] = request.remote_ip
    ri[:language_code] = input[:message][:from][:language_code]
    ri[:payload_received] = input #request.body.read
    ri[:payload_received_reply] = input_reply
    ri[:payload_sent] = output
    ri[:payload_sent_method] = output_method
    ri[:payload_sent_reply] = output
    ri[:payload_result] = JSON.parse(response.body)
    ri[:process_status] = response.code
    ri.save

    # render json: { input: input, input_reply: input_reply, output_method: output_method, output: output }
    render json: input_reply
  end


  private




  def parse(input)
    output = {method: 'sendMessage', text: "Sorry I can't understand you", reply_markup: {"remove_keyboard":true,"selective":false}}
    if input[:message][:from][:language_code] == 'es'

    else
      decissions_en = {
        # /I18n.t 'hello'/ => {method: 'sendMessage', text: I18n.t("default_message") },
        /hi/ => {method: 'sendMessage', text: "hello"},
        /next meetup/ => {method: 'sendMessage', text: "next meetup will be "},
        /\/start/     => {method: 'sendMessage', text: "Hello I'm malagarb_bot , ¿how can I help you?", reply_markup: {"remove_keyboard":true,"selective":false}},
        /\/stop/      => {method: 'sendMessage', text: "I hope I have been useful, thank you.", reply_markup: {"remove_keyboard":true,"selective":false}}
      }
      decissions_en.each do |k,v|
          output = v if k.match? input[:message][:text].downcase
      end
    end
    next_meetup = MeetupDateGenerator.next_meetup(Time.now.year, Time.now.month, Time.now.day)
    # output = { text: "Hello I'm malagarb_bot , how can I help you?"}
    output[:chat_id] = input[:message][:chat][:id]
    output[:text] << next_meetup
    return output, "sendMessage"
  end



end
