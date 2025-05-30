Rails.application.routes.draw do
  root 'data_structures#index'

  get 'data_structures', to: 'data_structures#index'
  get 'algorithms', to: 'algorithms#index'
  get 'quiz', to: 'quiz#index'

  resources :data_structures, only: [:index]

  post 'linked_list_action', to: 'data_structures#linked_list_action'
  post 'doubly_linked_list_action', to: 'data_structures#doubly_linked_list_action'
  post 'stack_action', to: 'data_structures#stack_action'
  post 'queue_action', to: 'data_structures#queue_action'
  post 'binary_tree_action', to: 'data_structures#binary_tree_action'

  post '/algorithms/merge_sort', to: 'algorithms#merge_sort'
  post '/algorithms/quick_sort', to: 'algorithms#quick_sort'
  post '/algorithms/generate_array', to: 'algorithms#generate_array'

  get '/quiz/categories', to: 'quiz#categories'
  get '/quiz/questions', to: 'quiz#questions'
  post '/quiz/submit_answer', to: 'quiz#submit_answer'
  get '/quiz/results', to: 'quiz#results'
  post '/quiz/reset_quiz', to: 'quiz#reset_quiz'

  resources :quiz, only: [:index]
end
