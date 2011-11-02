# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "veritas-td/version"

Gem::Specification.new do |s|
  s.name        = "veritas-tutorial-d"
  s.version     = Veritas::TD::VERSION
  s.authors     = ["d11wtq"]
  s.email       = ["chris@w3style.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Tutorial D Interpreter for Veritas}
  s.description = %q{Use the Tutorial D language put forward by Christopher Date and Hugh Darwen
                     to define and query Veritas relations}

  s.rubyforge_project = "veritas-tutorial-d"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.6"

  s.add_runtime_dependency "veritas"
  s.add_runtime_dependency "parslet"
end
