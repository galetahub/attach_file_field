# encoding: utf-8
module AttachFileField
  module Utils
    extend ActionView::Helpers::UrlHelper
    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::JavaScriptHelper
    
    def self.convert_options(options={})
      str = []
      options.each do |k, v|
        next if v.blank?
        
        value = case v.class.to_s
          when 'String' then "'#{v}'"
          when 'Hash' then "{ #{ckeditor_applay_options(v)} }"
          else v
        end
        str << "#{k}: #{value}"
      end
      
      str.join(',')
    end
    
    # file-types
	  def self.block_file_types(dom_id, file_title, file_max_size)
	    content_tag(:div, 
	      content_tag(:span, nil, :id => "#{dom_id}_swfbutton") +
	      content_tag(:div, nil, :style => "display:inline;margin-left:20px;", :id => "#{dom_id}_swffilename") +
	      content_tag(:div, content_tag(:span, "#{file_title}. #{I18n.t('manage.max_size')}:") + 
	                        content_tag(:strong, "#{file_max_size} MB"), :class=>"type-info"),
	      :class=>"file-types")
	  end
	  
	  #<div class="ill-bl">
    # <div class="r-ill">
    #  <div class="r-ill-data">
    #   <span class="file-name">file name</span>
    #   <a class="del" href="#"><img alt="del" src="images/cross_ico.gif"/></a>
    #  </div>
    # </div>
    # <div class="l-ill">
    #  <a href="#"><img alt="foto" src="images/foto.jpg"/></a>
    # </div>
    #</div>
	  def self.block_image(dom_id, value)
	    block_image_id = "#{dom_id}_asset"
	    
	    return content_tag(:div, nil, :class => "ill-bl", :id => block_image_id, :style=>"display:none;") if value.nil?
	    
	    filename = content_tag(:span, value.filename, :class=>"file-name")
	    del_link = link_to(tag("image", :src => '/attach_file_field/images/cross_ico.gif', :alt=>'delete'), "/manage/assets/#{value.id}", :remote => true, :method => :delete, :confirm => I18n.t('manage.confirm_delete'), :class => "del attach_file_delete")

	    image = tag("image", :src => value.url(:thumb), :alt=>value.filename, :title=>value.filename)
	    
      content_tag(:div,
       content_tag(:div, 
        content_tag(:div, 
          filename + del_link, 
          :class=>"r-ill-data"),
        :class=>"r-ill") +
       content_tag(:div, image, :class=>"l-ill"),
       :class=>"ill-bl", :id=>block_image_id)
	  end
	  
	  def self.swfobject_script(dom_id, upload_path, options={})
	    button_img = options.delete(:button_img)
	    button_id = "#{dom_id}_swfbutton"
	    file_types = options.delete(:file_types) || '*.jpg;*.jpeg;*.png;*.gif;*.tiff'
	    file_max_size = options.delete(:file_max_size) || 10
	    
	    debug = Rails.env.development? ? 'true' : 'false'
	    
	    js = "
	      var swfu_#{dom_id} = null;
	      
	      function swfupload_#{dom_id}() {
			    swfu_#{dom_id} = new SWFUpload({
				    // Backend settings
				    upload_url: #{upload_path.inspect},
				    post_params: { #{convert_options(options)} },
				    file_post_name: 'data_file',

				    // Flash file settings
				    file_size_limit : '#{file_max_size} MB',
				    file_types : #{file_types.inspect},
				    file_types_description : 'Files',
				    file_upload_limit : 20,
				    file_queue_limit : 1,

				    // The event handler functions are defined in handlers.js
				    //swfupload_loaded_handler : swf_UploadLoaded,
				    
				    //file_dialog_start_handler: swf_fileDialogStart,
				    file_queued_handler : swf_fileQueued,
				    file_queue_error_handler : swf_fileQueueError,
				    file_dialog_complete_handler : swf_fileDialogComplete,
				    
				    //upload_start_handler : swf_uploadStart,
				    upload_progress_handler : swf_uploadProgress,
				    upload_error_handler : swf_uploadError,
				    upload_success_handler : swf_uploadSuccess,
				    upload_complete_handler : swf_uploadComplete,
				    queue_complete_handler : swf_queueComplete,	// Queue plugin event

				    // Button Settings
				    button_image_url : #{button_img.inspect},
				    button_placeholder_id : #{button_id.inspect},
				    button_width: 92,
				    button_height: 18,
				    button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				    button_cursor: SWFUpload.CURSOR.HAND,
				
				    // Flash Settings
				    flash_url : '/attach_file_field/swf/swfupload.swf',

				    custom_settings : { 
        		  cancelButtonId : 'btn_cancel',
        		  progressGuid : #{dom_id.inspect}
				    },
				
				    // Debug settings
				    debug: #{debug}
			    });
		  };
		
		  $(document).ready(function(){
		    swfupload_#{dom_id}();
		    
		    // Ajax callback
		    $('a.attach_file_delete').bind('ajax:complete', function(){
          $(this).parents('div.ill-bl').hide();
         });
		  });"
		  
	    javascript_tag(js)
	  end
  end
end
