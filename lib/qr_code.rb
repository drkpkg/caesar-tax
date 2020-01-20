# frozen_string_literal: true

require 'rqrcode'

# Extension for Caesar
module QrGenerator
  @qr_code = nil

  # @return [Object]
  def to_qr
    control_exception_for(@owner_document)
    @qr_code = RQRCode::QRCode.new(str_format)
  end

  # @param [String] path
  # @return [Object]
  def save(path)
    to_qr
    png = @qr_code.as_png(bit_depth: 1,
                          border_modules: 4,
                          color_mode: ChunkyPNG::COLOR_GRAYSCALE,
                          color: 'black',
                          file: nil,
                          fill: 'white',
                          module_px_size: 6,
                          resize_exactly_to: false,
                          resize_gte_to: false,
                          size: 200)
    IO.write(path, png.to_s)
  end
end
