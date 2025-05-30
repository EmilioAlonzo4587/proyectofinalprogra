module DataStructures
  # Nodo para lista enlazada simple
  class ListNode
    attr_accessor :value, :next_node

    def initialize(value)
      @value = value
      @next_node = nil
    end
  end

  # Lista enlazada simple
  class LinkedList
    attr_accessor :head, :size

    def initialize
      @head = nil
      @size = 0
    end

    def prepend(value)
      new_node = ListNode.new(value)
      new_node.next_node = @head
      @head = new_node
      @size += 1
    end

    def append(value)
      new_node = ListNode.new(value)
      
      if @head.nil?
        @head = new_node
      else
        current = @head
        current = current.next_node while current.next_node
        current.next_node = new_node
      end
      @size += 1
    end

    def delete(value)
      return false if @head.nil?

      if @head.value == value
        @head = @head.next_node
        @size -= 1
        return true
      end

      current = @head
      while current.next_node && current.next_node.value != value
        current = current.next_node
      end

      if current.next_node
        current.next_node = current.next_node.next_node
        @size -= 1
        return true
      end

      false
    end

    def find(value)
      current = @head
      index = 0
      while current
        return index if current.value == value
        current = current.next_node
        index += 1
      end
      nil
    end

    def to_array
      result = []
      current = @head
      while current
        result << current.value
        current = current.next_node
      end
      result
    end

    def clear
      @head = nil
      @size = 0
    end
  end

  # Nodo para lista doblemente enlazada
  class DoublyListNode
    attr_accessor :value, :next_node, :prev_node

    def initialize(value)
      @value = value
      @next_node = nil
      @prev_node = nil
    end
  end

  # Lista doblemente enlazada
  class DoublyLinkedList
    attr_accessor :head, :tail, :size

    def initialize
      @head = nil
      @tail = nil
      @size = 0
    end

    def prepend(value)
      new_node = DoublyListNode.new(value)

      if @head.nil?
        @head = new_node
        @tail = new_node
      else
        new_node.next_node = @head
        @head.prev_node = new_node
        @head = new_node
      end
      @size += 1
    end

    def append(value)
      new_node = DoublyListNode.new(value)

      if @tail.nil?
        @head = new_node
        @tail = new_node
      else
        @tail.next_node = new_node
        new_node.prev_node = @tail
        @tail = new_node
      end
      @size += 1
    end

    def delete(value)
      current = @head

      while current
        if current.value == value
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

          @size -= 1
          return true
        end
        current = current.next_node
      end

      false
    end

    def find(value)
      current = @head
      index = 0
      while current
        return index if current.value == value
        current = current.next_node
        index += 1
      end
      nil
    end

    def to_array
      result = []
      current = @head
      while current
        result << current.value
        current = current.next_node
      end
      result
    end

    def to_reverse_array
      result = []
      current = @tail
      while current
        result << current.value
        current = current.prev_node
      end
      result
    end

    def clear
      @head = nil
      @tail = nil
      @size = 0
    end
  end

  # Pila (Stack)
  class Stack
    def initialize
      @items = []
    end

    def push(value)
      @items.push(value)
    end

    def pop
      @items.pop
    end

    def peek
      @items.last
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

    def clear
      @items.clear
    end
  end

  # Cola (Queue)
  class Queue
    def initialize
      @items = []
    end

    def enqueue(value)
      @items.push(value)
    end

    def dequeue
      @items.shift
    end

    def front
      @items.first
    end

    def rear
      @items.last
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

    def clear
      @items.clear
    end
  end

  # Nodo para árbol binario
  class TreeNode
    attr_accessor :value, :left, :right

    def initialize(value)
      @value = value
      @left = nil
      @right = nil
    end
  end

  # Árbol binario de búsqueda
  class BinarySearchTree
    attr_accessor :root

    def initialize
      @root = nil
    end

    def insert(value)
      @root = insert_node(@root, value)
    end

    def delete(value)
      @root = delete_node(@root, value)
    end

    def search(value)
      search_node(@root, value)
    end

    def in_order
      result = []
      in_order_traversal(@root, result)
      result
    end

    def height
      calculate_height(@root)
    end

    def clear
      @root = nil
    end

    private

    def insert_node(node, value)
      return TreeNode.new(value) if node.nil?

      if value < node.value
        node.left = insert_node(node.left, value)
      elsif value > node.value
        node.right = insert_node(node.right, value)
      end

      node
    end

    def delete_node(node, value)
      return nil if node.nil?

      if value < node.value
        node.left = delete_node(node.left, value)
      elsif value > node.value
        node.right = delete_node(node.right, value)
      else
        return node.right if node.left.nil?
        return node.left if node.right.nil?

        min_right = find_min(node.right)
        node.value = min_right.value
        node.right = delete_node(node.right, min_right.value)
      end

      node
    end

    def find_min(node)
      node = node.left while node.left
      node
    end

    def search_node(node, value)
      return false if node.nil?
      return true if node.value == value

      if value < node.value
        search_node(node.left, value)
      else
        search_node(node.right, value)
      end
    end

    def in_order_traversal(node, result)
      return if node.nil?

      in_order_traversal(node.left, result)
      result << node.value
      in_order_traversal(node.right, result)
    end

    def calculate_height(node)
      return 0 if node.nil?

      1 + [calculate_height(node.left), calculate_height(node.right)].max
    end
  end
end
