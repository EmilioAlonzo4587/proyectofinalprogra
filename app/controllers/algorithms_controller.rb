class AlgorithmsController < ApplicationController
  # Deshabilitar verificación CSRF para requests AJAX
  skip_before_action :verify_authenticity_token, only: [:merge_sort, :quick_sort, :generate_array, :test]
  
  def index
    @default_array = []
  end

  # Endpoint de prueba
  def test
    render json: { 
      success: true, 
      message: "Server is working!", 
      timestamp: Time.current 
    }
  end

  def merge_sort
    Rails.logger.info "=== MERGE SORT REQUEST ==="
    Rails.logger.info "Params: #{params.inspect}"
    
    begin
      # Verificar que el parámetro array existe
      unless params[:array].present?
        render json: { 
          success: false, 
          error: "Array parameter is required" 
        }, status: 400
        return
      end

      array = params[:array].map(&:to_i)
      Rails.logger.info "Array to sort: #{array.inspect}"
      
      service = MergeSortService.new(array)
      steps = service.generate_steps
      
      Rails.logger.info "Generated #{steps.length} steps"
      
      render json: { 
        success: true, 
        steps: steps,
        algorithm: 'merge_sort'
      }
    rescue => e
      Rails.logger.error "Error in merge_sort: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      render json: { 
        success: false, 
        error: e.message 
      }, status: 500
    end
  end

  def quick_sort
    Rails.logger.info "=== QUICK SORT REQUEST ==="
    Rails.logger.info "Params: #{params.inspect}"
    
    begin
      # Verificar que el parámetro array existe
      unless params[:array].present?
        render json: { 
          success: false, 
          error: "Array parameter is required" 
        }, status: 400
        return
      end

      array = params[:array].map(&:to_i)
      Rails.logger.info "Array to sort: #{array.inspect}"
      
      service = QuickSortService.new(array)
      steps = service.generate_steps
      
      Rails.logger.info "Generated #{steps.length} steps"
      
      render json: { 
        success: true, 
        steps: steps,
        algorithm: 'quick_sort'
      }
    rescue => e
      Rails.logger.error "Error in quick_sort: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      render json: { 
        success: false, 
        error: e.message 
      }, status: 500
    end
  end

  def generate_array
    Rails.logger.info "=== GENERATE ARRAY REQUEST ==="
    
    begin
      size = params[:size]&.to_i || 10
      max_value = params[:max_value]&.to_i || 100
      
      # Validaciones
      size = [size, 20].min # Máximo 20 elementos
      size = [size, 3].max  # Mínimo 3 elementos
      max_value = [max_value, 200].min # Máximo valor 200
      max_value = [max_value, 10].max  # Mínimo valor 10
      
      array = Array.new(size) { rand(1..max_value) }
      
      Rails.logger.info "Generated array: #{array.inspect}"
      
      render json: { 
        success: true, 
        array: array 
      }
    rescue => e
      Rails.logger.error "Error in generate_array: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      render json: { 
        success: false, 
        error: e.message 
      }, status: 500
    end
  end
end
