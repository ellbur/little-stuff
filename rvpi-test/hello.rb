
require 'rubygems'
require 'ruby-vpi'

print "\n\n"

def step
    print "--\n"
    VPI.advance_time
end

joe = VPI.vpi_handle_by_name('joe'.to_s, nil)
p joe
print "a = #{joe.a.intVal}\n"
print "b = #{joe.b.intVal}\n"
print "c = #{joe.c.intVal}\n"

joe.a.put_value 1
joe.b.put_value 1
step
print "c = #{joe.c.intVal}\n"

print "\n\n"

