module DryUtil
  include Dry::Transaction::Operation

  def self.included(including_obj)
    including_obj.define_singleton_method(:call) do |params|
      params[:debug] ? new(params, debug: true).call : new(params).call
    end
  end

  attr_reader :params
  def initialize(params, debug: false)
    @params = params
    add_debug if debug
  end

  private

  def add_debug
    if params[:debug].is_a? Debug
      params[:debug] << inspect
    else
      params[:debug] = Debug.new([inspect])
    end
  end

  class Debug < Array
    KLASS_MATCHER = /\A#<(?<klass>[A-Z]+[A-Za-z]{0,})/

    def operation_list
      map do |e|
        e.match(KLASS_MATCHER)
         .named_captures['klass']
      end
    end
  end
  private_constant :Debug
end
