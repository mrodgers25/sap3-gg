Rails.application.config.generators do |g|
  # Disable generators we don't need.
  g.orm                 :active_record
  g.template_engine     :erb
  g.test_framework      :rspec
  g.scaffold_stylesheet false
  g.stylesheets         false
  g.javascripts         false
  g.jbuilder            false
  g.coffee              false
  g.scss                false
  g.helper              false
end