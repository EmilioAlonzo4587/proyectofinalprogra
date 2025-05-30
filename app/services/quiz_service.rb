class QuizService
  class Question
    attr_accessor :id, :type, :category, :difficulty, :question, :code, :options, :correct_answer, :explanation

    def initialize(attributes = {})
      attributes.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    def to_h
      {
        id: id,
        type: type,
        category: category,
        difficulty: difficulty,
        question: question,
        code: code,
        options: options,
        correct_answer: correct_answer,
        explanation: explanation
      }
    end
  end

  class Category
    attr_accessor :id, :name, :description, :icon, :question_count

    def initialize(attributes = {})
      attributes.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    def to_h
      {
        id: id,
        name: name,
        description: description,
        icon: icon,
        question_count: question_count
      }
    end
  end

  def self.categories
    [
      Category.new(
        id: 'searching',
        name: 'Algoritmos de Búsqueda',
        description: 'Preguntas sobre algoritmos de búsqueda como búsqueda lineal, binaria, etc.',
        icon: '🔍',
        question_count: 3
      ),
      Category.new(
        id: 'complexity',
        name: 'Complejidad Algorítmica',
        description: 'Preguntas sobre análisis de complejidad temporal y espacial.',
        icon: '📈',
        question_count: 3
      )
    ]
  end

  def self.all_questions
    [
      Question.new(
        id: 'q1',
        type: 'true-false',
        category: 'searching',
        difficulty: 'easy',
        question: 'La búsqueda binaria puede aplicarse a cualquier array, ordenado o no.',
        correct_answer: 'false',
        explanation: 'Falso. La búsqueda binaria requiere que el array esté ordenado para funcionar correctamente. Si el array no está ordenado, la lógica de dividir el espacio de búsqueda basándose en comparaciones no funcionará.'
      ),
      Question.new(
        id: 'q2',
        type: 'true-false',
        category: 'searching',
        difficulty: 'easy',
        question: 'El algoritmo de búsqueda lineal revisa cada elemento de la lista uno por uno hasta encontrar el valor buscado:',
        correct_answer: "true",
        explanation: 'Verdadero. Porque compara el valor buscado con cada elemento, en orden, hasta hallarlo o llegar al final.'
      ),
      Question.new(
        id: 'q3',
        type: 'true-false',
        category: 'searching',
        difficulty: 'easy',
        question: 'Los algoritmos de búsqueda solo se utilizan en programación para encontrar números:',
        correct_answer: "false",
        explanation: 'Falso. Porque también se usan para buscar palabras, objetos o cualquier tipo de dato, no solo números.'
      ),
      Question.new(
        id: 'q4',
        type: 'true-false',
        category: 'complexity',
        difficulty: 'easy',
        question: 'La complejidad algorítmica mide el tiempo o espacio que necesita un algoritmo para resolverse:',
        correct_answer: "true",
        explanation: 'Verdadero. Porque la complejidad se refiere a los recursos (tiempo y memoria) que usa un algoritmo al ejecutarse.'
      ),
      Question.new(
        id: 'q5',
        type: 'true-false',
        category: 'complexity',
        difficulty: 'easy',
        question: 'Si dos algoritmos tienen la misma notación Big O, siempre tendrán el mismo rendimiento en la práctica:',
        correct_answer: "false",
        explanation: 'Falso. Porque Big O ignora constantes y otros factores; dos algoritmos con la misma complejidad pueden tener diferentes tiempos reales de ejecución.'
      ),
      Question.new(
        id: 'q6',
        type: 'true-false',
        category: 'complexity',
        difficulty: 'easy',
        question: 'Un algoritmo de complejidad constante O(1) es más eficiente que uno de O(n), sin importar el tamaño de los datos:',
        correct_answer: "true",
        explanation: 'Verdadero. Porque en O(1) el tiempo de ejecución no depende del tamaño de la entrada, siempre es igual.'
      )
    ]
  end

  def self.questions_for_category(category_id)
    all_questions.select { |q| q.category == category_id }
  end

  def self.check_answer(question, user_answer)
    correct_answer = question['correct_answer']
    
    case question['type']
    when 'multiple-answer'
      return false unless user_answer.is_a?(Array) && correct_answer.is_a?(Array)
      user_answer.sort == correct_answer.sort
    when 'short-answer'
      user_answer.to_s.downcase.include?(correct_answer.to_s.downcase)
    else
      user_answer.to_s == correct_answer.to_s
    end
  end

  def self.get_evaluation(percentage)
    case percentage
    when 80..100
      { level: 'Excelente', color: 'green', message: '¡Excelente trabajo! Tienes un gran dominio de este tema.' }
    when 60..79
      { level: 'Bueno', color: 'blue', message: 'Buen trabajo. Tienes una buena comprensión, pero aún hay espacio para mejorar.' }
    when 40..59
      { level: 'Regular', color: 'yellow', message: 'Estás en el camino correcto, pero necesitas repasar más este tema.' }
    else
      { level: 'Necesita mejorar', color: 'red', message: 'Te recomendamos revisar este tema con más detalle antes de intentarlo nuevamente.' }
    end
  end
end