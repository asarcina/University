require 'thread'
class RoutingTable

attr_accessor :table , :distance_vector

def initialize( links )
  #links matrice 2xN 
  @mutex=Mutex.new
  @table=[]
  links.each do |r|
   @row = {:destination_address => "", :next_hop=>"", :tot_cost=>""}

   @row[:destination_address]=r[0]
   @row[:next_hop]=r[0]
   @row[:tot_cost]=r[1]
   @table << @row
  end

end
def getDistanceVector
  @mutex.synchronize do
  
  @distance_vector=[]
  
  @table.each do |h|
    entry={:destination_address => "", :tot_cost=>""}
    entry[:destination_address]=h[:destination_address]
    entry[:tot_cost]=h[:tot_cost]
    @distance_vector << entry
    end
  end
  return @distance_vector
end
def update_table(index, newPathCost, new_next_hop )
  #area sincronizzata
  @mutex.synchronize do
    @table[index][:next_hop]=new_next_hop
    @table[index][:tot_cost]=newPathCost
  end
  
end
def insert_new_row(destination_address, next_hop,tot_cost)
  @mutex.synchronize do
  @row = {:destination_address => "", :next_hop=>"", :tot_cost=>""}
  @row = {:destination_address => destination_address, :next_hop=>next_hop, :tot_cost=>tot_cost}
  @table << @row
  
  end
end

def print_distance_vector(dvN, addressN)
  puts "............DIST-VECTOR node"+addressN.to_s+"........."
  dvN.each do |row|
      puts "Destination: "+row[:destination_address].to_s+ "\tCost:"+row[:tot_cost].to_s
  end
  puts ".........................................."
end

def print_routing_table(node, status=[])
 
 if status==[] then
   va={:inserted=>0, :updated=>0}
 else
   va=status[node]
 end 
 
 puts "--------------node "+node.to_s+" --------------"
 @table.each do |row|
   puts "Destination: "+row[:destination_address].to_s+ "\tNext Hop: "+row[:next_hop].to_s+"\tCost:"+row[:tot_cost].to_s
 
 end 
 puts "----inserted: "+va[:inserted].to_s+" ------updated: "+va[:updated].to_s+" -------"
end
  
end
