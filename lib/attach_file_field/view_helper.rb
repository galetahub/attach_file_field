# encoding: utf-8
module AttachFileField
  module ViewHelper
  
    # form.attach_file(:picture, :swf_params=>{:assetable_type=>'Post', 
    #                  :assetable_id=>@post.try(:id)},
    #                  :file_max_size=>2,
    #                  :upload_path=>new_asset_path_with_session_information('Picture')) %>
    #                            
	  def attach_file_tag(object_name, method_name, options={})
	    object = options.delete(:object) if options.key?(:object)
      object ||= @template.instance_variable_get("@#{object}")
      
      value = object.send(method_name.to_sym)
      value ||= object.find_by_giud(method_name.to_sym)
      guid = object.send("#{method_name}_hidden")
      
      sanitized_object_name = object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
      sanitized_method_name = method_name.to_s.sub(/\?$/,"")
            
      dom_id = [sanitized_object_name, sanitized_method_name].join('_')
	    button_img = "/attach_file_field/images/select_file.gif"
	    upload_path = options[:upload_path] || new_asset_path_with_session_information(method_name)
	    
	    file_title = options[:file_title] || "JPEG, GIF, PNG or TIFF"
	    file_max_size = options[:file_max_size] || 10
	    
	    label = I18n.t("helpers.label.#{object_name}.#{method_name}", :default => "").presence

	    label ||= if object && object.class.respond_to?(:human_attribute_name)
        object.class.human_attribute_name(method_name)
      end

      label ||= method_name.humanize
	    
	    inputs = ActiveSupport::SafeBuffer.new
	    inputs << content_tag(:div, label, :class=>"gr-title")
	    inputs << Utils::block_image(dom_id, value)
	    inputs << Utils::block_file_types(dom_id, file_title, file_max_size)
      inputs << attach_hidden_field(object_name, method_name, object)
      inputs << content_tag(:div, nil, :id=>"#{dom_id}_progress")
	    
	    swf_params = options[:swf_params] || {}
	    swf_params[:assetable_type] ||= object.class.name
      swf_params[:assetable_id] ||= object.try(:id)
	    swf_params.update({:button_img => button_img, :file_max_size => file_max_size})
	    swf_params[:guid] ||= guid
	    
	    output_buffer = ActiveSupport::SafeBuffer.new
	    output_buffer << content_tag(:div, content_tag(:div, inputs, :class=>"bg-bl"), :class=>"gray-blocks")
	    output_buffer << Utils::swfobject_script(dom_id, upload_path, swf_params)
	    
	    output_buffer
	  end
	  
	  def new_asset_path_with_session_information(klass='Asset', options = {})
      options.symbolize_keys!
      session_key = Rails.application.config.send(:session_options)[:key]
      
      options[session_key] = Rack::Utils.escape(@template.cookies[session_key])
      options[:format] = :xml
      options[:protocol] = "http://"
      options[:klass] = klass
      
      if @template.protect_against_forgery?
        options[@template.request_forgery_protection_token] = Rack::Utils.escape(@template.form_authenticity_token)
      end
            
      @template.send(:manage_assets_url, options)
    end
	  
	  def attach_include_files
	    files = ["swfupload.js", "swfupload.queue.js", "fileprogress.js", "handlers.js"]
	    
	    javascript_include_tag(files.map{|f| "/attach_file_field/javascripts/#{f}" })
	  end
	  
	  def attach_hidden_field(object, field, var, value=nil)
	    ActionView::Base::InstanceTag.new(object, "#{field}_hidden", self, var).to_input_field_tag("hidden")
	  end
  end
end
