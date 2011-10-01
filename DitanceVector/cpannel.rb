class Cpannel
  
def thread_exit_pannel(threads)
   
  Thread.new do 
    server=TCPServer.open(12000)
  loop{
      c=server.accept
        command=""
        while input = c.gets
        command=command+input
        end
        if(command.include? "exit")
            process_to_kill=command.scan(/[0-9]/)
            puts " Uccidi "+ process_to_kill.to_s
            Thread.kill(threads[process_to_kill.to_i])
            puts threads
        end
        c.close
      }
  end
end




end
