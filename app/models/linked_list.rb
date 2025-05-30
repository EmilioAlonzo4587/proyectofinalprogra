class LinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  def append(data)
    new_node = Node.new(data)
    
    if @head.nil?
      @head = new_node
    else
      current = @head
      while current.next_node
        current = current.next_node
      end
      current.next_node = new_node
    end
  end

  def prepend(data)
    new_node = Node.new(data)
    new_node.next_node = @head
    @head = new_node
  end

  def delete(data)
    return if @head.nil?

    if @head.data == data
      @head = @head.next_node
      return
    end

    current = @head
    while current.next_node && current.next_node.data != data
      current = current.next_node
    end

    if current.next_node
      current.next_node = current.next_node.next_node
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
