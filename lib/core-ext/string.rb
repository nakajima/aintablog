# Move this to plugin
class String
  def query_params
    params = Hash.new([].freeze)
    query_string = self.match(/\?(.*)/).try :[], 1
    
    return { } if query_string.blank?
    
    query_string.to_s.split(/[&;]/n).each do |pairs|
      key, value = pairs.split('=',2).collect{|v| CGI::unescape(v) }
      if params.has_key?(key)
        params[key].push(value)
      else
        params[key] = [value]
      end
    end
    params
  end
  
  def append_params(new_params={})
    split = self.split(/\?/)
    old_params = self.query_params
    new_params.each { |key, value| old_params[key] = value }
    str_params = old_params.inject([]) do |memo, pair|
      memo << pair.join('=')
      memo
    end.join('&')
    res = split[0]
    res += ('?' + str_params) unless str_params.blank?
    res
  end
  
  def append_params!(new_params={})
    res = append_params(new_params)
    gsub!(self, res)
  end
end