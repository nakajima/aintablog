module SyntaxFu
  TYPES = {
   'Apache' => 'apache',
   'CSS' => 'css',
   'HTML' => 'html_rails',
   'Javascript' => 'javascript_+_prototype',
   'Markdown' => 'markdown',
   'Perl' => 'perl',
   'PHP' => 'php',
   'Plain Text' => 'plain_text',
   'Ruby' => 'ruby',
   'Ruby on Rails' => 'ruby_on_rails',
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

require 'syntax_fu/string_extensions'