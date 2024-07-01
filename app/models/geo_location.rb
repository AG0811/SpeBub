# # app/models/geo_location.rb
# require 'maxmind-geoip2'
# Rails.logger.info "maxmind-geoip2 gem loaded successfully"

# class GeoLocation
#   DATABASE_PATH = Rails.root.join('db', 'geoip', 'GeoLite2-City.mmdb')

#   def self.lookup(ip_address)
#     Rails.logger.info "Looking up IP address: #{ip_address}"
#     database = MaxMind::GeoIP2::Database.new(DATABASE_PATH)
#     record = database.lookup(ip_address)
#     {
#       city: record&.city&.name || 'Unknown',
#       state: record&.subdivisions&.first&.name || 'Unknown'
#     }
#   end
# end


# app/models/geo_location.rb
require 'maxminddb'
Rails.logger.info "maxminddb gem loaded successfully"

class GeoLocation
  DATABASE_PATH = Rails.root.join('db/geoip/', 'GeoLite2-City.mmdb')

  def self.lookup(ip_address)
    Rails.logger.info "Looking up IP address: #{ip_address}"
    database = MaxMindDB.new(DATABASE_PATH)
    record = database.lookup(ip_address)
    {
      city: record&.city&.name || 'Unknown',
      state: record&.subdivisions&.first&.name || 'Unknown'
    }
  end
end
