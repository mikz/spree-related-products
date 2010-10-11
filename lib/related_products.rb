# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'
require 'spree_core'
require "related_products_hooks"

module RelatedProducts
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate

      # Calculator::RelatedProductDiscount.register #FIXME: disabled for now, get this working with Spree 0.30

      Product.class_eval do
        has_many :relations, :as => :relatable

        def self.relation_types
          RelationType.find_all_by_applies_to(self.to_s, :order => :name)
        end

        def method_missing(method)
          relation_type =  self.class.relation_types.detect { |rt| rt.name.downcase.gsub(" ", "_").pluralize == method.to_s.downcase }

          if relation_type.nil?
            super(method)
          else
            relations.find_all_by_relation_type_id(relation_type.id).map(&:related_to).select {|product| product.deleted_at.nil? && product.available_on <= Time.now()}
          end

        end
      end

      Admin::ProductsController.class_eval do
        def related
          load_object
          @relation_types = Product.relation_types
        end
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
