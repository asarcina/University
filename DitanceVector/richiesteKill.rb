require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 12000
console=gets
s = TCPSocket.open(hostname, port)
s.puts(console)

s.close        
