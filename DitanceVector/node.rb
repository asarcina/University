require 'routing_table'
require 'socket'
class Nodes
  #variabili 
  #hash DV incicizzato sui nomi dei nodi
  # indirizzo del nodo
  #Tabella instradamento
  
  #il nodo deve anche aprire una socket server e una client appena inizializzato
  attr_accessor :address , :rtable , :dist_vec , :port
    
  def initialize(node_address,links)
    #inizializzo il nome del nodo
    #inizializzo la tabella di instradamento a 0
    #definisco le connessioni quindi una mappa dei nodi vicini
    #inizializzo il DV con i vicini
    @address = node_address
    @port=10000
    @rtable=RoutingTable.new links
    @dist_vec=@rtable.getDistanceVector 
    @port=@port + @address
    #puts @rtable.table
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
        data=Marshal.dump(@dist_vec)
        client.puts data
        puts @address
        client.close
        end
    }
  end

def get_neighbors
  
  neighbors=[]
  @rtable.table.each do |row|
      if row[:next_hop]==row[:destination_address]
        d=row[:destination_address]
        c=row[:tot_cost]
        neighbor={:destination_address=>d, :cost=>c}
        #puts "vicino nodo "+@address.to_s+" :"+neighbor[:destination_address].to_s
        neighbors<<neighbor
      end 
    end 
  neighbors 
end  
  
end

