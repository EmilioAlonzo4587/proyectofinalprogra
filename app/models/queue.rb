class Queue
  def initialize
    @items = []
  end

  def enqueue(item)
    @items.push(item)
  end

  def dequeue
    @items.shift
  end

  def front
    @items.first
  end

  def empty?
    @items.empty?
  end

  def size
    @items.size
  end

  def to_array
    @items.dup
  end
end
