require 'node'
require 'socket'

#ogni nodo mi fa partire un thread che dovrà simulare  un nodo indipendente su una macchina distinta
threads=[]
nodes=[]
#n1=Nodes.new 1 , [[2,1],[4,2],[6,9]] 
#n2=Nodes.new 1 , [[1,4],[3,1]] 
#n3=Nodes.new 1 , [[2,1],[3,1]] 
#n4=Nodes.new 1 , [[1,4],[4,1]] 
#n1.rtable.table
#n2.rtable.table
#n3.rtable.table
#n4.rtable.table
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

params.each do |p|
 
  threads << Thread.new do
    node=Nodes.new(p[:address] , p[:links]) 
    nodes << node
    puts "nodo creato" + p[:address].to_s
    #inizializzo i server che risponderanno alle richieste degli altri nodi che vogliono il distance vetctor
    thread_server=Thread.new{node.start_server}
   
   
      #periodicamente controllo nella mia RoutingTable i nodi vicini dove destination_address==next_hop e li metto in un vettore
    #per ogni nodi vicino nel vettore apro una socket client e richiedo il distance_vector del relativo nodo
    #eseguo confronto e verifico con la mia RoutingTable se è il caso aggiorno altrimenti no
      
    count=0
    
    while(count <= max) do
     
      neighbors=node.get_neighbors
      puts "vicini nodo: "+node.address.to_s
      neighbors.each{|n| puts n[:destination_address].to_s }
      
      neighbors.each do |n|
        data=""
        port=10000+n[:destination_address]
        s=TCPSocket.open(hostname, port)
        while line=s.gets
         data=data+line
        end
      #distance vector da analizzare
      #check dv con routing_table e :tot_cost del vicino ed eventualmente aggiorno
        dv=Marshal.load(data)
      
        s.close
      end# each
      
      sleep(60)
      puts " fatto"
      count=count+1
    end #while count
    
    thread_server.join
    end

 end
 
 
threads.each{|t| t.join}
