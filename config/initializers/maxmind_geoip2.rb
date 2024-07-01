



require 'maxminddb'

# GeoLite2データベースへのパスを設定する
db = MaxMindDB.new('./db/geoip/GeoLite2-City.mmdb')