module SyntaxFu
  module StringExtensions
    def syntaxify(options={})
      options[:lang] ||= 'ruby'
      options[:theme]  ||= 'eiffel'
      return self unless SyntaxFu.valid_syntax?(options[:lang])
      parse(self, options)
    end

    private
    def parse(text, options={})
      case
      when options[:lang].match(/textile/i): use_markup_library(:red_cloth, text)
      when options[:lang].match(/markdown/i): use_markup_library(:maruku, text)
      else
        with_extras(Uv.parse(self, 'xhtml', options[:lang].to_s, options[:line_numbers], options[:theme]), options[:lang])
      end
    end

    def with_extras(str, lang)
      case
      when lang.match(/javascript/)
        str.gsub!(/(function|var)/, '<span class="Keyword">\1</span>')
        str.gsub!(/\b(Object|document|window)/, '<span class="Special">\1</span>')
        str
      when lang.match(/ruby/)
        str.gsub! /<span class="Keyword">def<\/span>\s<span class="FunctionName">([\w\!\?]+)<\/span>/,
          "<span class=\"Keyword\">def</span> <span class=\"FunctionName MethodName\">#{'\1'}</span>"
        str.gsub!(/FunctionName/, '')
        str.gsub!(/MethodName/, 'FunctionName')
        str.gsub!(/(self)/, '<span class="Special">\1</span>')
        str
      else
        str
      end
    end

    def use_markup_library(library, text)
      str = %{<div class="markup #{@format}">}
      str += library.to_s.classify.constantize.new(text).to_html
      str += '</div>'
      return str
    end
  end
end


String.send :include, SyntaxFu::StringExtensions
