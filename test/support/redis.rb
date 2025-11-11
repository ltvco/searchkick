options = {}
options[:logger] = $logger if !defined?(RedisClient)

redis_url = ENV["REDIS_URL"]

Searchkick.redis =
  if !defined?(Redis)
    RedisClient.config(url: redis_url).new_pool
  elsif defined?(ConnectionPool)
    ConnectionPool.new { Redis.new(url: redis_url, **options) }
  else
    Redis.new(url: redis_url, **options)
  end

module RedisInstrumentation
  def call(command, redis_config)
    $logger.info "[redis] #{command.inspect}"
    super
  end

  def call_pipelined(commands, redis_config)
    $logger.info "[redis] #{commands.inspect}"
    super
  end
end
RedisClient.register(RedisInstrumentation) if defined?(RedisClient)
