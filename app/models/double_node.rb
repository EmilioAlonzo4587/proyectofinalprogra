class DoubleNode
  attr_accessor :data, :next_node, :prev_node

  def initialize(data)
    @data = data
    @next_node = nil
    @prev_node = nil
  end
end
