require 'routing_table'
class Nodes
  #variabili 
  #hash DV incicizzato sui nomi dei nodi
  # indirizzo del nodo
  #Tabella instradamento
  attr_accessor :address , :rtable , :dist_vec
  
  def initialize(node_address,links)
    #inizializzo il nome del nodo
    #inizializzo la tabella di instradamento a 0
    #definisco le connessioni quindi una mappa dei nodi vicini
    #inizializzo il DV con i vicini
    @address = node_address
    @rtable=RoutingTable.new links
    @dist_vec=@rtable.getDistanceVector
#    puts @rtable.table
#    puts @address
#    puts "----------"
#    puts @dist_vec
#    
  end
  #@rtable.each{|r| puts r}
  
  
end

