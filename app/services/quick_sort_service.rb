class QuickSortService
  def initialize(array)
    @original_array = array.dup
    @steps = []
    @sorted_indices = Set.new
  end

  def generate_steps
    Rails.logger.info "QuickSortService: Starting with array #{@original_array.inspect}"
    
    @steps = []
    @sorted_indices = Set.new
    working_array = @original_array.dup
    indices = (0...working_array.length).to_a
    
    # Paso inicial
    add_step(working_array, [], nil, [], "Array inicial")
    
    # Ejecutar quick sort
    quick_sort(working_array, 0, working_array.length - 1, indices) if working_array.length > 1
    
    # Paso final
    add_step(working_array, [], nil, (0...working_array.length).to_a, "Array completamente ordenado")
    
    Rails.logger.info "QuickSortService: Generated #{@steps.length} steps"
    @steps
  end

  private

  def quick_sort(array, low, high, indices)
    return if low >= high

    # Particionar
    pi = partition(array, low, high, indices)
    @sorted_indices.add(indices[pi])

    add_step(array, [], nil, @sorted_indices.to_a, "Pivote #{array[pi]} está en su posición final")

    # Recursión
    quick_sort(array, low, pi - 1, indices)
    quick_sort(array, pi + 1, high, indices)
  end

  def partition(array, low, high, indices)
    pivot = array[high]
    i = low - 1

    add_step(array, [], high, @sorted_indices.to_a, "Seleccionando pivote: #{pivot}")

    (low...high).each do |j|
      add_step(array, [j, high], high, @sorted_indices.to_a, "Comparando #{array[j]} con pivote #{pivot}")

      if array[j] < pivot
        i += 1
        # Intercambiar elementos
        array[i], array[j] = array[j], array[i]
        indices[i], indices[j] = indices[j], indices[i]

        add_step(array, [i, j], high, @sorted_indices.to_a, "Intercambiando #{array[j]} y #{array[i]}")
      end
    end

    # Colocar el pivote en su posición correcta
    array[i + 1], array[high] = array[high], array[i + 1]
    indices[i + 1], indices[high] = indices[high], indices[i + 1]

    i + 1
  end

  def add_step(array, comparing, pivot, sorted, description)
    step = {
      array: array.dup,
      comparing: comparing || [],
      pivot: pivot,
      sorted: sorted || [],
      description: description || ""
    }
    
    @steps << step
    Rails.logger.debug "Added step: #{description}"
  end
end
