class MergeSortService
  def initialize(array)
    @original_array = array.dup
    @steps = []
  end

  def generate_steps
    Rails.logger.info "MergeSortService: Starting with array #{@original_array.inspect}"
    
    @steps = []
    working_array = @original_array.dup
    
    # Paso inicial
    add_step(working_array, [], [], [], "Array inicial")
    
    # Ejecutar merge sort
    merge_sort(working_array, 0, working_array.length - 1) if working_array.length > 1
    
    # Paso final
    add_step(working_array, [], [], (0...working_array.length).to_a, "Array completamente ordenado")
    
    Rails.logger.info "MergeSortService: Generated #{@steps.length} steps"
    @steps
  end

  private

  def merge_sort(array, left, right, level = 0)
    return if left >= right

    mid = (left + right) / 2

    # Mostrar división
    add_step(array, [], [], [], "Dividiendo array en [#{left}..#{mid}] y [#{mid + 1}..#{right}]")

    # Recursión
    merge_sort(array, left, mid, level + 1)
    merge_sort(array, mid + 1, right, level + 1)

    # Combinar
    merge(array, left, mid, right)
  end

  def merge(array, left, mid, right)
    # Crear copias de los subarrays
    left_array = array[left..mid].dup
    right_array = array[(mid + 1)..right].dup

    merging_indices = (left..right).to_a
    add_step(array, [], merging_indices, [], "Combinando subarrays [#{left_array.join(', ')}] y [#{right_array.join(', ')}]")

    i = 0
    j = 0
    k = left

    # Combinar los arrays ordenados
    while i < left_array.length && j < right_array.length
      comparing_indices = [left + i, mid + 1 + j]
      add_step(array, comparing_indices, merging_indices, [], "Comparando #{left_array[i]} y #{right_array[j]}")

      if left_array[i] <= right_array[j]
        array[k] = left_array[i]
        i += 1
      else
        array[k] = right_array[j]
        j += 1
      end

      add_step(array, [], merging_indices, [], "Colocando #{array[k]} en posición #{k}")
      k += 1
    end

    # Copiar elementos restantes del subarray izquierdo
    while i < left_array.length
      array[k] = left_array[i]
      add_step(array, [], merging_indices, [], "Copiando elemento restante #{left_array[i]}")
      i += 1
      k += 1
    end

    # Copiar elementos restantes del subarray derecho
    while j < right_array.length
      array[k] = right_array[j]
      add_step(array, [], merging_indices, [], "Copiando elemento restante #{right_array[j]}")
      j += 1
      k += 1
    end

    # Marcar subarray como ordenado
    sorted_indices = (left..right).to_a
    add_step(array, [], [], sorted_indices, "Subarray [#{left}..#{right}] combinado correctamente")
  end

  def add_step(array, comparing, merging, sorted, description)
    step = {
      array: array.dup,
      comparing: comparing || [],
      merging: merging || [],
      sorted: sorted || [],
      description: description || ""
    }
    
    @steps << step
    Rails.logger.debug "Added step: #{description}"
  end
end
