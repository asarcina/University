class RoutingTable

attr_accessor :table , :distance_vector

def initialize( links )
  #links matrice 2xN 
  
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
  entry={:destination_address => "", :tot_cost=>""}
  @distance_vector=[]
  
  @table.each do |h|
    entry[:destination_address]=h[:destination_address]
    entry[:tot_cost]=h[:tot_cost]
    @distance_vector << entry
    end
  return @distance_vector
end
  
end
