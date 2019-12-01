if Rails.env.development?
  Resque.redis = Redis.new(host: 'localhost', port: '6379')
else
  REDIS = Redis.new(url: ENV['REDISTOGO_URL'])
  Resque.redis = REDIS
end

Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
Resque.logger.level = Logger::DEBUG
