class DoublyLinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def append(data)
    new_node = DoubleNode.new(data)
    
    if @head.nil?
      @head = new_node
      @tail = new_node
    else
      @tail.next_node = new_node
      new_node.prev_node = @tail
      @tail = new_node
    end
  end

  def prepend(data)
    new_node = DoubleNode.new(data)
    
    if @head.nil?
      @head = new_node
      @tail = new_node
    else
      new_node.next_node = @head
      @head.prev_node = new_node
      @head = new_node
    end
  end

  def delete(data)
    current = @head
    
    while current
      if current.data == data
        if current.prev_node
          current.prev_node.next_node = current.next_node
        else
          @head = current.next_node
        end
        
        if current.next_node
          current.next_node.prev_node = current.prev_node
        else
          @tail = current.prev_node
        end
        
        return
      end
      current = current.next_node
    end
  end

  def find(data)
    current = @head
    while current
      return current if current.data == data
      current = current.next_node
    end
    nil
  end

  def to_array
    result = []
    current = @head
    while current
      result << current.data
      current = current.next_node
    end
    result
  end

  def to_reverse_array
    result = []
    current = @tail
    while current
      result << current.data
      current = current.prev_node
    end
    result
  end

  def size
    count = 0
    current = @head
    while current
      count += 1
      current = current.next_node
    end
    count
  end
end

