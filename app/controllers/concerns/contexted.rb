module Contexted
  extend ActiveSupport::Concern

  protected

  def set_context
    @context = context_klass.find(context_id)
  end

  def context_klass
    params[:context].constantize
  end

  def context_id
    params["#{context_klass.to_s.downcase}_id".to_sym]
  end
end
