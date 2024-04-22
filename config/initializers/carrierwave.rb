CarrierWave.configure do |config|
  config.root = Rails.root.join('public')
  config.store_dir = 'uploads'
end
