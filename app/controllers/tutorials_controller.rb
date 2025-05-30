class TutorialsController < ApplicationController
  def index
    @initial_array = [64, 34, 25, 12, 22, 11, 90]
  end

  def bubble_sort_steps
    array = params[:array]&.map(&:to_i) || [64, 34, 25, 12, 22, 11, 90]
    steps = BubbleSortService.new(array).generate_steps
    
    render json: { steps: steps }
  end

  def generate_steps
    array = params[:array]&.map(&:to_i) || [64, 34, 25, 12, 22, 11, 90]
    steps = BubbleSortService.new(array).generate_steps
    
    render json: { steps: steps }
  end
end