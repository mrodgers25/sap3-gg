# def every_x_secs
#     while true
#       # yield
#       puts "thread loop every 2 secs"
#       sleep 2
#     end
# end

def every_x_secs
  thread = Thread.new do
    while true
      # yield
      puts "thread loop every 2 secs"
      sleep 2
    end
  end
  return thread
  # thread.join
end

every_x_secs

# x = Thread.new { sleep 0.1; print "x"; print "y"; print "z" }
# a = Thread.new { print "a"; print "b"; sleep 0.2; print "c" }.ruby-version.11.02.2014-06:19:55
# x.join # Let the threads finish before
# a.join # main thread exits...every_x_secs