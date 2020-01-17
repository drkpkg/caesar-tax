
class Cases
  require 'alleged_rc4'
  # Cases file
  # NRO. AUTORIZACION
  # NRO. FACTURA
  # NIT/CI
  # FECHA EMISION
  # MONTO FACTURADO
  # LLAVE DOSIFICACION
  # VERHOEFF
  # CADENA
  # SUMATORIA PRODUCTOS
  # BASE64
  # CODIGO CONTROL
  def initialize
    @data = []
    file = File.open('cases.txt')
    file.readlines.each do |line|
      line_array = line.split('|')
      @data.push(line_array[0,line_array.length-1])
    end
  end
end

Cases.new