# # config/initializers/maxmind_geoip2.rb
# require 'maxmind/geoip2'

# # ライセンスキーとアカウントIDを設定する
# MaxMind::GeoIP2.configure do |config|
#   config.account_id  = '1032741'
#   config.license_key = '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'
#   config.logger      = Rails.logger
# end



require 'maxminddb'

# GeoLite2データベースへのパスを設定する
db = MaxMindDB.new('./db/geoip/GeoLite2-City.mmdb')