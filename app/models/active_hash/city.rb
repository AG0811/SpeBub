# app/models/active_hash/city.rb

class City < ActiveHash::Base
  self.data = [
    { id: 1, name: 'Sapporo', prefecture: 'Hokkaido' },
    { id: 2, name: 'Hakodate', prefecture: 'Hokkaido' },
    { id: 3, name: 'Asahikawa', prefecture: 'Hokkaido' },
    { id: 4, name: 'Aomori', prefecture: 'Aomori' },
    { id: 5, name: 'Morioka', prefecture: 'Iwate' },
    { id: 6, name: 'Sendai', prefecture: 'Miyagi' },
    { id: 7, name: 'Akita', prefecture: 'Akita' },
    { id: 8, name: 'Yamagata', prefecture: 'Yamagata' },
    { id: 9, name: 'Fukushima', prefecture: 'Fukushima' },
    { id: 10, name: 'Mito', prefecture: 'Ibaraki' },
    { id: 11, name: 'Utsunomiya', prefecture: 'Tochigi' },
    { id: 12, name: 'Maebashi', prefecture: 'Gunma' },
    { id: 13, name: 'Saitama', prefecture: 'Saitama' },
    { id: 14, name: 'Chiba', prefecture: 'Chiba' },
    { id: 15, name: 'Tokyo', prefecture: 'Tokyo' },
    { id: 16, name: 'Yokohama', prefecture: 'Kanagawa' },
    { id: 17, name: 'Niigata', prefecture: 'Niigata' },
    { id: 18, name: 'Toyama', prefecture: 'Toyama' },
    { id: 19, name: 'Kanazawa', prefecture: 'Ishikawa' },
    { id: 20, name: 'Fukui', prefecture: 'Fukui' },
    { id: 21, name: 'Kofu', prefecture: 'Yamanashi' },
    { id: 22, name: 'Nagano', prefecture: 'Nagano' },
    { id: 23, name: 'Gifu', prefecture: 'Gifu' },
    { id: 24, name: 'Shizuoka', prefecture: 'Shizuoka' },
    { id: 25, name: 'Nagoya', prefecture: 'Aichi' },
    { id: 26, name: 'Tsushima', prefecture: 'Mie' },
    { id: 27, name: 'Otsu', prefecture: 'Shiga' },
    { id: 28, name: 'Kyoto', prefecture: 'Kyoto' },
    { id: 29, name: 'Osaka', prefecture: 'Osaka' },
    { id: 30, name: 'Sakai', prefecture: 'Osaka' },
    { id: 31, name: 'Kobe', prefecture: 'Hyogo' },
    { id: 32, name: 'Nara', prefecture: 'Nara' },
    { id: 33, name: 'Wakayama', prefecture: 'Wakayama' },
    { id: 34, name: 'Tottori', prefecture: 'Tottori' },
    { id: 35, name: 'Matsue', prefecture: 'Shimane' },
    { id: 36, name: 'Okayama', prefecture: 'Okayama' },
    { id: 37, name: 'Hiroshima', prefecture: 'Hiroshima' },
    { id: 38, name: 'Yamaguchi', prefecture: 'Yamaguchi' },
    { id: 39, name: 'Tokushima', prefecture: 'Tokushima' },
    { id: 40, name: 'Takamatsu', prefecture: 'Kagawa' },
    { id: 41, name: 'Matsuyama', prefecture: 'Ehime' },
    { id: 42, name: 'Kochi', prefecture: 'Kochi' },
    { id: 43, name: 'Fukuoka', prefecture: 'Fukuoka' },
    { id: 44, name: 'Saga', prefecture: 'Saga' },
    { id: 45, name: 'Nagasaki', prefecture: 'Nagasaki' },
    { id: 46, name: 'Kumamoto', prefecture: 'Kumamoto' },
    { id: 47, name: 'Oita', prefecture: 'Oita' },
    { id: 48, name: 'Miyazaki', prefecture: 'Miyazaki' },
    { id: 49, name: 'Kagoshima', prefecture: 'Kagoshima' },
    { id: 50, name: 'Naha', prefecture: 'Okinawa' }
    # 必要に応じて他の都市名と都道府県のマッピングを追加する
  ]

  def self.find_by_prefecture(prefecture_name)
    where(prefecture: prefecture_name)
  end

  def self.find_by_name(city_name)
    find_by(name: city_name)
  end
end
