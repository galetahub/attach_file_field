# encoding: utf-8
require 'digest/sha1'

module AttachFileField
  autoload :Utils,        'attach_file_field/utils'
  autoload :ViewHelper,   'attach_file_field/view_helper'
  autoload :FormBuilder,  'attach_file_field/form_builder'
  autoload :Middleware,   'attach_file_field/middleware'
  autoload :Version,      'attach_file_field/version'
  
  module Base
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
      # acts_as_attach_file :avatar
    	def acts_as_attach_file(*args)
    	  options = args.extract_options!
    	  
    	  columns = args.collect { |c| "#{c}_hidden" }
    	  
    	  # no bulk assignment
        if protected_attributes.blank?
          attr_accessible *columns
        end
    	  
    	  attr_accessor :attach_file_guids
    	  
    		definitions = []
    		
    		args.each do |column|
    			definitions << "def #{column}_hidden=(value)"
		      definitions << "return super unless value.is_a?(String)"
		      definitions << "@attach_file_guids ||= {}"
		      definitions << "@attach_file_guids[:#{column.to_s}] = value"
		      definitions << "@#{column}_hidden = value"
		      definitions << "end"
		
		      definitions << "def #{column}_hidden"
		      definitions << "@#{column}_hidden ||= generate_default_guid(#{column.inspect})"
		      definitions << "@#{column}_hidden"
		      definitions << "end"
    		end
    		
    		include InstanceMethods
    		
    		after_save  :update_attached_files
    		
    		class_eval <<-EOV
          #{definitions.join("\n")}
        EOV
	    end
    end

    module InstanceMethods
      def update_attach_file(method, guid)
        return if method.blank? || guid.blank?
        
        ref = self.class.reflections[method.to_sym]
        
        unless ref.nil?
          ref.klass.update_all(["assetable_id = ?, guid = NULL", self.id], ["guid = ?", guid])
        else
          #TODO: detect class name
        end
      end
      
      def update_attached_files
        unless @attach_file_guids.nil?
    	    @attach_file_guids.each do |k, v|
    	      update_attach_file(k, v)
    	    end
        end
      end
      
      def find_by_giud(method)
        guid = self.send("#{method}_hidden")
        self.class.reflections[method].klass.find_by_guid(guid)
      end
      
      def generate_default_guid(method)
        Digest::SHA1.hexdigest("--#{Time.now.to_s}-#{method}--attach-")[0..9]
      end
    end
  end
end

require 'attach_file_field/railtie'
