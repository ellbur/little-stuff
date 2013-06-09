
require 'rubygems'
require 'ruby-vpi'
require 'rake'

sources = ['joe.v']
p "Sources are #{sources}"

# From runner.rb, sort of
OBJECT_PATH = '/var/lib/gems/1.8/gems/ruby-vpi-21.1.0/obj'
LOADER_FUNC = 'vlog_startup_routines_bootstrap'
p "OBJECT_PATH = #{OBJECT_PATH}"
p "LOADER_FUNC = #{LOADER_FUNC}"

# From runner.rb
# Returns the path to the Ruby-VPI object file for the given simulator.
def object_file_path aSimId # :nodoc:
  path = File.expand_path File.join(OBJECT_PATH, "#{aSimId}.so")
  p "path = #{path}"

  unless File.exist? path
    raise "Object file #{path.inspect} is missing. Rebuild Ruby-VPI."
  end

  path
end

# From runner.rb, sort of
args = [
    'cver',
    "+loadvpi=#{object_file_path('cver')}:#{LOADER_FUNC}",
    sources
]
p "args = #{args.join ' '}"
sh args

