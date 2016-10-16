# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path("default_avatar/" + [version_name, "missing.png"].compact.join('/'))
  end

  version :thumb do
    eager
    resize_to_fill(100, 100)
  end

  version :medium do
    eager
    resize_to_fill(300, 300)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
