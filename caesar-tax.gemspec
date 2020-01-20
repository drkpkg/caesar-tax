# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'caesar-tax'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Gema para impuestos internos de Bolivia'
  s.description = 'Much longer explanation of the example!'
  s.authors     = ['Felix Daniel Coca Calvimontes']
  s.email       = 'daniel.uremix@gmail.com'
  s.files       = %w[lib/caesar.rb lib/allegedrc4.rb lib/base64.rb lib/qr_code.rb lib/verhoeff.rb]
  s.homepage    = 'https://rubygems.org/gems/caesar-tax'
  s.metadata    = { "source_code_uri" => 'https://github.com/drkpkg/caesar-tax' }
  s.require_paths = ['lib']
end
