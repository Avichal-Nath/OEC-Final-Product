# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# config/importmap.rb

pin "application", preload: true
pin "@rails/ujs", to: "https://cdnjs.cloudflare.com/ajax/libs/rails-ujs/6.1.4/rails-ujs.min.js", preload: true
pin "bootstrap", to: "https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js", preload: true
