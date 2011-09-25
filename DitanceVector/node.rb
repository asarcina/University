require 'routing_table'
class Nodes
  #variabili 
  #hash DV incicizzato sui nomi dei nodi
  # indirizzo del nodo
  #Tabella instradamento
  
  #il nodo deve anche aprire una socket server e una client appena inizializzato
  attr_accessor :address , :rtable , :dist_vec , :port
    @port=10000
  def initialize(node_address,links)
    #inizializzo il nome del nodo
    #inizializzo la tabella di instradamento a 0
    #definisco le connessioni quindi una mappa dei nodi vicini
    #inizializzo il DV con i vicini
    @address = node_address
    @rtable=RoutingTable.new links
    @dist_vec=@rtable.getDistanceVector 
    @port=@port+node_address.to_i
   puts @rtable.table
#    puts @address
#    puts "----------"
#    puts @dist_vec
#    

  end
  
  def start_server
    server=TCPServer.open(@port)
    loop{
      Thread.start(server.accept) do |client|
        #--------------
        #funzione da eseguire sul client
        #invio dv
        client.close
        end
    }
  end
  
  
end

