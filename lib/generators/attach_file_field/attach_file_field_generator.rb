require 'rails/generators'

class AttachFileFieldGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  end
  
  def copy_javascripts 
    copy_file(
      'javascripts/fileprogress.js',
      'public/attach_file_field/javascripts/fileprogress.js'
    )
    copy_file(
      'javascripts/handlers.js',
      'public/attach_file_field/javascripts/handlers.js'
    )
    copy_file(
      'javascripts/swfupload.js',
      'public/attach_file_field/javascripts/swfupload.js'
    )
    copy_file(
      'javascripts/swfupload.queue.js',
      'public/attach_file_field/javascripts/swfupload.queue.js'
    )
  end
  
  def copy_swf
    copy_file(
      'swf/expressInstall.swf',
      'public/attach_file_field/swf/expressInstall.swf'
    )
    
    copy_file(
      'swf/swfupload.swf',
      'public/attach_file_field/swf/swfupload.swf'
    )
  end
  
  def copy_images
    directory "images", "public/attach_file_field/images"
  end
end
