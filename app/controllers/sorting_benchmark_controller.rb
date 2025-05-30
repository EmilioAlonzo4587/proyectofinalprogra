class SortingBenchmarkController < ApplicationController
  before_action :initialize_sorting_methods_metadata

  def dashboard
    @dataset_size = params[:dataset_size]&.to_i || 50
    @primary_method = params[:primary_method] || 'bubble_algorithm'
    @secondary_method = params[:secondary_method] || 'quicksort_algorithm'
    @current_dataset = session[:current_dataset] || []
  end

  def create_random_dataset
    size = params[:size].to_i
    dataset = Array.new(size) { rand(1..100) }
    session[:current_dataset] = dataset
    
    render json: { dataset: dataset }
  end

  def execute_performance_test
    primary_method_key = params[:primary_method]
    secondary_method_key = params[:secondary_method]
    dataset = session[:current_dataset] || []

    if dataset.empty?
      render json: { error: 'No dataset available for testing' }, status: 400
      return
    end

    performance_analyzer = SortingPerformanceAnalyzer.new
    primary_result = performance_analyzer.benchmark_sorting_method(primary_method_key, dataset.dup)
    secondary_result = performance_analyzer.benchmark_sorting_method(secondary_method_key, dataset.dup)

    render json: {
      primary_result: primary_result.merge(method_name: @sorting_methods_metadata[primary_method_key.to_sym][:name]),
      secondary_result: secondary_result.merge(method_name: @sorting_methods_metadata[secondary_method_key.to_sym][:name]),
      methods_metadata: {
        primary_method: @sorting_methods_metadata[primary_method_key.to_sym],
        secondary_method: @sorting_methods_metadata[secondary_method_key.to_sym]
      }
    }
  end

  private

  def initialize_sorting_methods_metadata
    @sorting_methods_metadata = {
      bubble_algorithm: {
        name: "Bubble Sort",
        temporal_complexity: "O(n²)",
        spatial_complexity: "O(1)",
        description: "Compara elementos adyacentes e intercambia si están en orden incorrecto"
      },
      quicksort_algorithm: {
        name: "Quick Sort",
        temporal_complexity: "O(n log n)",
        spatial_complexity: "O(log n)",
        description: "Divide y vencerás usando un pivote para particionar el array"
      },
      mergesort_algorithm: {
        name: "Merge Sort",
        temporal_complexity: "O(n log n)",
        spatial_complexity: "O(n)",
        description: "Divide el array recursivamente y luego combina las partes ordenadas"
      },
      selection_algorithm: {
        name: "Selection Sort",
        temporal_complexity: "O(n²)",
        spatial_complexity: "O(1)",
        description: "Encuentra el elemento mínimo y lo coloca en la posición correcta"
      },
      insertion_algorithm: {
        name: "Insertion Sort",
        temporal_complexity: "O(n²)",
        spatial_complexity: "O(1)",
        description: "Construye el array ordenado insertando elementos uno por uno"
      }
    }
  end
end