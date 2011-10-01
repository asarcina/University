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
        data=Marshal.dump(@rtable.getDistanceVector)
        client.puts data
        #puts @address
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
        @neighbor={:destination_address=>d, :cost=>c}
        #puts "vicino nodo "+@address.to_s+" :"+neighbor[:destination_address].to_s
        neighbors<<@neighbor
        
      end
    end
   neighbors
  end

  def check_and_update( dvN , costN, addressN)
   
    status={:updated=>0 ,:inserted=>0  }
    
    dvN.each do |h|
      
      newPathCost=h[:tot_cost]+costN
      new_next_hop=addressN
      
      selected=@rtable.table.select{ |row| row[:destination_address]==h[:destination_address]}
     
      # puts "Voglio verifivare del nodo "+@address.to_s+" la nuova destinazione "+h[:destination_address].to_s+" con next_hop "+new_next_hop.to_s+" e costo "+newPathCost.to_s
      
      if selected!=[]
        if(selected.first[:tot_cost]>newPathCost)
          #update routing_table
          index=@rtable.table.index(selected.first)
          @rtable.update_table(index, newPathCost, new_next_hop )
          status[:updated]=status[:updated]+1
        end
      else if h[:destination_address]!= @address
       #insert new row in table
       #puts "Voglio inserire nella RT del nodo"+@address.to_s+" la nuova destinazione "+h[:destination_address].to_s+" con next_hop "+new_next_hop.to_s+" e costo "+newPathCost.to_s
       @rtable.insert_new_row(h[:destination_address], new_next_hop, newPathCost)
       status[:inserted]= status[:inserted]+1
      end

    end
#    if status[:inserted]>0 || status[:updated]>0 then
      @dist_vec=@rtable.getDistanceVector
   # end
    return status
  end

end
end
