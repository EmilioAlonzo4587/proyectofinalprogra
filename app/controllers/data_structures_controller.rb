class DataStructuresController < ApplicationController
  before_action :initialize_structures

  def index
    @current_tab = params[:tab] || 'linked_list'

    @items = @doubly_linked_list.to_array

    @reverse = params[:reverse] == "true"

    ejecutar_accion("invertir_array", @items) if @reverse
  end

  def linked_list_action
    value = params[:value].to_i if params[:value].present?
    
    case params[:action_type]
    when 'prepend'
      @linked_list.prepend(value) if value
    when 'append'
      @linked_list.append(value) if value
    when 'delete'
      @linked_list.delete(value) if value
    when 'search'
      session[:linked_list_search] = value if value
    when 'clear'
      @linked_list.clear
      session[:linked_list_search] = nil
    end

    session[:linked_list] = @linked_list.to_array
    redirect_to data_structures_path(tab: 'linked_list')
  end

  def doubly_linked_list_action
    value = params[:value].to_i if params[:value].present?
    
    case params[:action_type]
    when 'prepend'
      @doubly_linked_list.prepend(value) if value
    when 'append'
      @doubly_linked_list.append(value) if value
    when 'delete'
      @doubly_linked_list.delete(value) if value
    when 'search'
      session[:doubly_linked_list_search] = value if value
    when 'toggle_reverse'
      session[:show_reverse] = !session[:show_reverse]
    when 'clear'
      @doubly_linked_list.clear
      session[:doubly_linked_list_search] = nil
    end

    session[:doubly_linked_list] = @doubly_linked_list.to_array
    redirect_to data_structures_path(tab: 'doubly_linked_list')
  end

  def stack_action
    value = params[:value].to_i if params[:value].present?
    
    case params[:action_type]
    when 'push'
      @stack.push(value) if value
    when 'pop'
      popped = @stack.pop
      session[:last_operation] = popped ? "Popped: #{popped}" : "Stack is empty"
    when 'peek'
      peeked = @stack.peek
      session[:last_operation] = peeked ? "Top element: #{peeked}" : "Stack is empty"
    when 'clear'
      @stack.clear
      session[:last_operation] = "Stack cleared"
    end

    session[:stack] = @stack.to_array
    redirect_to data_structures_path(tab: 'stack')
  end

  def queue_action
    value = params[:value].to_i if params[:value].present?
    
    case params[:action_type]
    when 'enqueue'
      @queue.enqueue(value) if value
    when 'dequeue'
      dequeued = @queue.dequeue
      session[:last_operation] = dequeued ? "Dequeued: #{dequeued}" : "Queue is empty"
    when 'front'
      front = @queue.front
      session[:last_operation] = front ? "Front element: #{front}" : "Queue is empty"
    when 'clear'
      @queue.clear
      session[:last_operation] = "Queue cleared"
    end

    session[:queue] = @queue.to_array
    redirect_to data_structures_path(tab: 'queue')
  end

  def binary_tree_action
    value = params[:value].to_i if params[:value].present?
    
    case params[:action_type]
    when 'insert'
      @binary_tree.insert(value) if value
    when 'delete'
      @binary_tree.delete(value) if value
    when 'search'
      if value
        found = @binary_tree.search(value)
        session[:tree_search_result] = found
        session[:tree_search_value] = value
      end
    when 'clear'
      @binary_tree.clear
      session[:tree_search_result] = nil
      session[:tree_search_value] = nil
    end

    session[:binary_tree] = serialize_tree(@binary_tree.root)
    redirect_to data_structures_path(tab: 'binary_tree')
  end

  private

  def initialize_structures
    # Initialize Linked List
    @linked_list = DataStructures::LinkedList.new
    if session[:linked_list]
      session[:linked_list].each { |item| @linked_list.append(item) }
    end
    @linked_list_search = session[:linked_list_search]

    # Initialize Doubly Linked List
    @doubly_linked_list = DataStructures::DoublyLinkedList.new
    if session[:doubly_linked_list]
      session[:doubly_linked_list].each { |item| @doubly_linked_list.append(item) }
    end
    @doubly_linked_list_search = session[:doubly_linked_list_search]
    @show_reverse = session[:show_reverse] || false

    # Initialize Stack
    @stack = DataStructures::Stack.new
    if session[:stack]
      session[:stack].each { |item| @stack.push(item) }
    end

    # Initialize Queue
    @queue = DataStructures::Queue.new
    if session[:queue]
      session[:queue].each { |item| @queue.enqueue(item) }
    end

    # Initialize Binary Tree
    @binary_tree = DataStructures::BinarySearchTree.new
    if session[:binary_tree]
      deserialize_tree(session[:binary_tree])
    end
    @tree_search_result = session[:tree_search_result]
    @tree_search_value = session[:tree_search_value]

    @last_operation = session[:last_operation]
    session[:last_operation] = nil
  end

  def serialize_tree(node)
    return nil if node.nil?
    
    {
      value: node.value,
      left: serialize_tree(node.left),
      right: serialize_tree(node.right)
    }
  end

  def deserialize_tree(data)
      return if data.nil?
      
      @binary_tree.insert(data[:value])
      deserialize_tree(data[:left]) if data[:left]
      deserialize_tree(data[:right]) if data[:right]
    end
  end

  def ejecutar_accion(accion, datos)
    Rails.logger.info datos;
      case accion
      when "invertir_array"
        mostrar_array_invertido(datos)
      else
        datos
      end
    end

    def mostrar_array_invertido(array)
      array.reverse!
  end