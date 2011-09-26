require 'node'

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

params=[
{:address=> 1, :links=>[[2,1],[4,2],[6,9]]},
{:address=> 2, :links=>[[1,4],[3,1]]},
{:address=> 3, :links=>[[2,1],[3,1]]},
{:address=> 4, :links=>[[1,4],[4,1]]}

]

max=10

params.each do |p|
 
  threads << Thread.new do
    node=Nodes.new(p[:address] , p[:links]) 
    nodes << node
    puts "nodo creato" + p[:address].to_s
    #inizializzo i server che risponderanno alle richieste degli altri nodi che vogliono il distance vetctor
    thread_server=Thread.new{node.start_server}
   
    count=0
    #while(count<=max) do
      #periodicamente controllo nella mia RoutingTable i nodi vicini dove destination_address==next_hop e li metto in un vettore
    #per ogni nodi vicino nel vettore apro una socket client e richiedo il distance_vector del relativo nodo
    #eseguo confronto e verifico con la mia RoutingTable se è il caso aggiorno altrimenti no
      
    #  end
    puts "vicini"
   puts node.get_neighbors
    
    thread_server.join
    end

 end
 
 
threads.each{|t| t.join}
