class Ahoy::Store < Ahoy::Stores::LogStore
  # customize here
  Ahoy.quiet = true
  Ahoy.visit_duration = 30.minutes
end
