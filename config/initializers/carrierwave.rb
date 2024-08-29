# frozen_string_literal: true

CarrierWave.configure do |config|
  config.storage = :file
  config.cache_dir = Rails.root.join('tmp/uploads').to_s

  # 如果你使用不同的雲端儲存服務（例如 AWS S3），可以在這裡設定
  # config.fog_credentials = {
  #   provider: 'AWS',
  #   aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  #   aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  #   region: ENV['AWS_REGION']
  # }
  # config.fog_directory  = ENV['AWS_BUCKET_NAME']
end
