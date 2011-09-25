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
params.each do |p|
 
  threads << Thread.new do
    nodes << Nodes.new(p[:address] , p[:links]) 
    puts "nodo creato" + p[:address].to_s
    end

 end
 
 
# threads.each{|t| t.join}
