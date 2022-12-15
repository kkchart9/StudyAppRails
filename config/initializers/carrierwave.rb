require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'


# CarrierWave.configure do |config|
#   config.storage :fog
#   config.fog_provider = 'fog/aws'
#   config.fog_directory  = 'studymanagement'
#   config.fog_credentials = {
#     provider: 'AWS',
#     aws_access_key_id: "AKIAZ67VTXJXPKB5Q7MO",
#     aws_secret_access_key: "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",
#     region: "ap-northeast-1",
#     path_style: true
#   }
#
# end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => "AWS",
      :region                => "ap-northeast-1",
      :aws_access_key_id     => "AKIAZ67VTXJXPKB5Q7MO",
      :aws_secret_access_key => "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"
    }
    config.fog_directory     =  'studymanagement'
  end
end
