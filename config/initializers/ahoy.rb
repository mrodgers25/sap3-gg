class Ahoy::Store < Ahoy::Stores::LogStore
  # customize here
  Ahoy.quiet = false
  Ahoy.visit_duration = 2.minutes
end
