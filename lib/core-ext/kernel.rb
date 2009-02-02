module Kernel
  # Yields to the URI or file
  def with_indifferent_io
    begin
      oi = uri.match(/file:/) ? File.open(uri.gsub(%r{^file://}, '')) : open(uri)
      yield oi
    ensure
      oi.close if oi
    end
  end
end