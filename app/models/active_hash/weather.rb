module ActiveHash
  class Weather < ActiveHash::Base
    self.data = [
      { id: 1, description: 'clear sky', japanese_description: '晴天' },
      { id: 2, description: 'few clouds', japanese_description: '晴れ時々曇り' },
      { id: 3, description: 'scattered clouds', japanese_description: '曇り時々晴れ' },
      { id: 4, description: 'broken clouds', japanese_description: '曇り' },
      { id: 5, description: 'shower rain', japanese_description: 'にわか雨' },
      { id: 6, description: 'rain', japanese_description: '雨' },
      { id: 7, description: 'thunderstorm', japanese_description: '雷雨' },
      { id: 8, description: 'snow', japanese_description: '雪' },
      { id: 9, description: 'mist', japanese_description: '霧' },
      { id: 10, description: 'light rain', japanese_description: '小雨' },
      { id: 11, description: 'overcast clouds', japanese_description: '厚い雲' },
      { id: 12, description: 'broken clouds', japanese_description: '抜ける曇り' },
      { id: 13, description: 'scattered clouds', japanese_description: 'まばらな曇り' },
      { id: 14, description: 'few clouds', japanese_description: '薄い雲' },
      { id: 15, description: 'clear sky', japanese_description: '快晴' }
    ]
  end
end
