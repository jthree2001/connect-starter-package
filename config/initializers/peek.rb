# List of Peek Views shown in the container
require 'peek'
Peek.into Peek::Views::Git if Rails.env == 'development'
Peek.into Peek::Views::PerformanceBar
Peek.into Peek::Views::PG
Peek.into Peek::Views::Redis
Peek.into Peek::Views::Resque
Peek.into Peek::Views::Connect

Peek::Railtie.configure do
  config.peek.adapter = :redis
end
