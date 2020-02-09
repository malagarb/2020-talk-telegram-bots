require 'httpx'
require 'dotenv'
Dotenv.load(".env")

namespace :bot do
  namespace :mode_polling do
    # desc "check mode that bot are working"
    # task mode_check: :environment do
    #   resp = HTTPX.get("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/getMe").to_s
    #   puts JSON.pretty_generate(JSON.parse(resp))
    #   # `curl -s https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/getMe`
    # end
    #
    # desc "TODO"
    # task mode_polling: :environment do
    #   resp = HTTPX.get("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/getUpdates").to_s
    #   puts JSON.pretty_generate(JSON.parse(resp))
    # end
    #
    #
    # desc "TODO"
    # task mode_polling: :environment do
    #   resp = HTTPX.get("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/getUpdates").to_s
    #   puts JSON.pretty_generate(JSON.parse(resp))
    # end
    #
    # desc "TODO"
    # task mode_webhook: :environment do
    #   resp = HTTPX.get("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/getMe").to_s
    #   puts JSON.pretty_generate(JSON.parse(resp))
    # end
  end

  namespace :mode_webhook do

    desc "generate a self signed certificate and place into config/certificate and request to telegram to use webhookmode"
    task generate_cert: :environment do
      openssl_installed = `which openssl`
      if openssl_installed.nil? || openssl_installed.empty?
        abort "try first with `sudo apt install openssl`"
      end
      openssl_installed = `which curl`
      if openssl_installed.nil? || openssl_installed.empty?
        abort "try first with `sudo apt install curl`"
      end

      Dir.chdir('../deploy/local/nginx/') do
        `openssl req -newkey rsa:2048 -sha256 -nodes -keyout cert_priv.key -x509 -days 365 -out cert_public.pem -subj "/C=ES/ST=Andalucia/L=Malaga/O=malagarb /CN=#{ENV['TELEGRAM_CERT_SELF_SIGNED_DOMAIN']}"`
      end
    end

    desc "send certificate to telegram"
    task send_cert: :environment do
      unless FileTest.exist? 'config/certificates/cert_public.pem'
        abort 'try firs with rake mode_webhook:generate_cert'
      end

      Dir.chdir('../deploy/local/nginx/') do
        `curl -F "url=https://telegram.stbnrivas.es:8443/api/v1/telegram/webhook" -F "certificate=@cert_public.pem" https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/setWebhook`
      end
    end

    desc "generate a self signed certificate and place into config/certificate and request to telegram to use webhookmode"
    task remove_cert: :environment do
      `rm ../deploy/local/nginx/cert_public.pem`
      `rm ../deploy/local/nginx/cert_priv.key`
    end



    desc "get webhook info "
    task info: :environment do
      resp = HTTPX.get("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/getWebhookInfo")
      puts JSON.pretty_generate(JSON.parse(resp.body))
    end


    desc "set webhook url where telegram will send the updates"
    task set_url: :environment do
      resp = HTTPX.get("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/setWebHook?url=#{ENV['TELEGRAM_WEBHOOK_URL']}")
      puts JSON.pretty_generate(JSON.parse(resp.body))
    end

    desc "unset webhook url where telegram will send the updates"
    task unset_url: :environment do
      resp = HTTPX.get("https://api.telegram.org/bot#{ENV['TELEGRAM_TOKEN']}/deleteWebhook")
      puts JSON.pretty_generate(JSON.parse(resp.body))

    end

  end

end
