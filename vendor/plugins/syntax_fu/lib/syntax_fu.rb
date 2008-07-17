module SyntaxFu
  TYPES = {
   'Apache' => 'apache',
   'CSS' => 'css',
   'HTML' => 'html_rails',
   'Javascript' => 'javascript_+_prototype',
   'Lisp' => 'lisp',
   'Markdown' => 'markdown',
   'Perl' => 'perl',
   'PHP' => 'php',
   'Plain Text' => 'plain_text',
   'Ruby' => 'ruby',
   'Ruby on Rails' => 'ruby_on_rails',
   'Scheme' => 'scheme',
   'Shell' => 'shell-unix-generic',
   'SQL' => 'sql',
   'Textile' => 'textile',
   'XML' => 'xml',
   'YAML' => 'yaml'
  }

  class << self
    def valid_syntax?(name)
      TYPES.values.include?(name)
    end

    def sorted_types
      TYPES.sort { |a, b| a[0] <=> b[0] }
    end
  end
end

begin
  require 'uv'
  require 'syntax_fu/string_extensions'
rescue LoadError
  # If uv not available, tries to set things up for Dan Webb's Javascript-based
  # code highlighter.
  module SyntaxFu
    module StringFallback
      def syntaxify(options={})
        return self unless SyntaxFu.valid_syntax?(options[:lang])
        result = %{<pre><code class="#{SyntaxFu::TYPES.index(options[:lang])}">}
        result += self
        result += %{</code></pre>}
        return result
      end
    end
  end
  
  String.send :include, SyntaxFu::StringFallback
end