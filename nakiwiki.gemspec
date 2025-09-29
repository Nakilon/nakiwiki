Gem::Specification.new do |spec|
  spec.name         = "nakiwiki"
  spec.version      = "0.0.0"
  spec.summary      = "Wikipedia functionality suitable for chat bots"

  spec.author       = "Victor Maslov aka Nakilon"
  spec.email        = "nakilon@gmail.com"
  spec.license      = "MIT"
  spec.metadata     = {"source_code_uri" => "https://github.com/nakilon/nakiwiki"}

  spec.add_dependency "infoboxer"

  spec.files        = %w{ LICENSE nakiwiki.gemspec lib/nakiwiki.rb }
end
