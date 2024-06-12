# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "ip_address", to: "ip_address.js"
pin "news_new_popup", to: "news_new_popup.js"
pin "news_edit_popup", to: "news_edit_popup.js"
pin "news_filter", to: "news_filter.js"