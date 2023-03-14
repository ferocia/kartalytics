module Lib
  def self.print_image(name: "file", image:)
    file_contents = Base64.strict_encode64(image.to_blob)
    file_name = Base64.strict_encode64(name)

    puts "\x1b]1337;File=name=#{file_name};inline=1;width=#{image.columns}px;height=#{image.rows}px:#{file_contents}\x07"
  end
end
