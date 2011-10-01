require 'node'
require 'socket'

#ogni nodo mi fa partire un thread che dovrà simulare  un nodo indipendente su una macchina distinta
threads=[]
nodes=[]

hostname='localhost'

params=[
{:address=> 1, :links=>[[2,2],[4,1],[5,5]]},
{:address=> 2, :links=>[[1,2],[3,4],[5,3]]},
{:address=> 3, :links=>[[2,4],[5,3],[6,2]]},
{:address=> 4, :links=>[[1,1],[6,2],[5,2]]},
{:address=> 5, :links=>[[1,5],[4,2],[2,3],[3,3]]},
{:address=> 6, :links=>[[3,2],[4,2]]}
]

max=10

trap("INT") {puts "\n Torni a trovarci :D" ; exit}


params.each do |p|
 
  threads << Thread.new do
    node=Nodes.new(p[:address] , p[:links]) 
    nodes << node
    #puts "nodo creato" + p[:address].to_s
    #inizializzo i server che risponderanno alle richieste degli altri nodi che vogliono il distance vetctor
    node.rtable.print_routing_table(node.address)
    thread_server=Thread.new{node.start_server}
   
   
      #periodicamente controllo nella mia RoutingTable i nodi vicini dove destination_address==next_hop e li metto in un vettore
    #per ogni nodi vicino nel vettore apro una socket client e richiedo il distance_vector del relativo nodo
    #eseguo confronto e verifico con la mia RoutingTable se è il caso aggiorno altrimenti no
      
    count=0
    
    while(count <= max) do
     status=[nodes.size]
      neighbors=node.get_neighbors
     # puts "vicini nodo: "+node.address.to_s
     # neighbors.each{|n| puts n[:destination_address].to_s }
      
      neighbors.each do |n|
        data=""
        port=10000+n[:destination_address]
        s=TCPSocket.open(hostname, port)
      #  puts node.address.to_s+"----------->"+n[:destination_address].to_s
        
        while line=s.gets
         data=data+line
        end
      #distance vector da analizzare
      #check dv con routing_table e :tot_cost del vicino ed eventualmente aggiorno
        dv=Marshal.load(data)
#        node.rtable.print_distance_vector(dv, n[:destination_address])
#        sleep(2)
        status[node.address] = node.check_and_update(dv,n[:cost], n[:destination_address])
        
        s.close
      end# each
      node.rtable.print_routing_table(node.address, status)
      sleep(20)
      
      count=count+1
      puts " new loop "+count.to_s
    end #while count
    
    thread_server.join
    end

 end
 
 
threads.each{|t| t.join}
