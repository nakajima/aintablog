config.cache_classes = true
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = true
config.action_controller.allow_forgery_protection    = false
config.action_mailer.delivery_method = :test

# smooth
config.gem 'mocha'
config.gem 'fixjour', :version => '0.1.0'