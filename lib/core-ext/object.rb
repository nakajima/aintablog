class Object
  def try(method, *args, &block)
    respond_to?(method) ? send(method, *args, &block) : nil
  end
end