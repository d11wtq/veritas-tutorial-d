require "bundler/gem_tasks"

desc "Start a Pry session in the context of this gem"
task "pry" do
  require 'pry'

  ENV["GROUP"] ? Bundler.require(:default, *(ENV["GROUP"].split.map! {|g| g.to_sym })) : Bundler.require
  ARGV.clear

  Pry.start
end
