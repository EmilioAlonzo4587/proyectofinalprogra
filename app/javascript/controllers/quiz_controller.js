import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "categoriesTab", "quizTab", "categoriesView", "quizView", "questionView", "completedView",
    "questionText", "optionsContainer", "codeBlock", "explanationContainer", "explanationIcon",
    "explanationTitle", "explanationText", "correctAnswerContainer", "correctAnswerContent",
    "difficultyBadge", "typeBadge", "questionCounter", "progressBar", "checkButton", "nextButton",
    "categoryName", "finalScore", "finalProgressBar", "finalPercentage", "evaluationBadge", "evaluationMessage"
  ]

  connect() {
    this.currentCategory = null
    this.questions = []
    this.currentQuestionIndex = 0
    this.userAnswers = {}
    this.score = 0
    this.showExplanation = false
    
    this.showCategories()
  }

  showCategories() {
    this.categoriesTabTarget.classList.add('active')
    this.quizTabTarget.classList.remove('active')
    this.quizTabTarget.disabled = true
    
    this.categoriesViewTarget.classList.remove('hidden')
    this.quizViewTarget.classList.add('hidden')
  }

  showQuiz() {
    if (!this.currentCategory) return
    
    this.categoriesTabTarget.classList.remove('active')
    this.quizTabTarget.classList.add('active')
    this.quizTabTarget.disabled = false
    
    this.categoriesViewTarget.classList.add('hidden')
    this.quizViewTarget.classList.remove('hidden')
  }

  async startQuiz(event) {
    const categoryId = event.target.dataset.categoryId
    this.currentCategory = categoryId
    
    try {
      const response = await fetch(`/quiz/questions?category_id=${categoryId}`, {
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })
      
      const data = await response.json()
      this.questions = data.questions
      this.currentQuestionIndex = 0
      this.userAnswers = {}
      this.score = 0
      this.showExplanation = false
      
      this.showQuiz()
      this.displayQuestion()
      
    } catch (error) {
      console.error('Error loading questions:', error)
      alert('Error al cargar las preguntas. Por favor, intenta de nuevo.')
    }
  }

  displayQuestion() {
    if (!this.questions || this.questions.length === 0) return
    
    const question = this.questions[this.currentQuestionIndex]
    
    // Update question info
    this.questionTextTarget.textContent = question.question
    this.questionCounterTarget.textContent = `Pregunta ${this.currentQuestionIndex + 1} de ${this.questions.length}`
    
    // Update progress bar
    const progress = ((this.currentQuestionIndex + 1) / this.questions.length) * 100
    this.progressBarTarget.style.width = `${progress}%`
    
    // Update difficulty badge
    const difficultyColors = {
      'easy': 'badge-easy',
      'medium': 'badge-medium',
      'hard': 'badge-hard'
    }
    const difficultyTexts = {
      'easy': 'Fácil',
      'medium': 'Medio',
      'hard': 'Difícil'
    }
    this.difficultyBadgeTarget.className = `difficulty-badge ${difficultyColors[question.difficulty]}`
    this.difficultyBadgeTarget.textContent = difficultyTexts[question.difficulty]
    
    // Update type badge
    const typeTexts = {
      'multiple-choice': 'Opción múltiple',
      'true-false': 'Verdadero/Falso',
      'multiple-answer': 'Múltiples respuestas',
      'code-completion': 'Completar código',
      'short-answer': 'Respuesta corta'
    }
    this.typeBadgeTarget.textContent = typeTexts[question.type]
    
    // Show/hide code block
    if (question.code) {
      this.codeBlockTarget.textContent = question.code
      this.codeBlockTarget.classList.remove('hidden')
    } else {
      this.codeBlockTarget.classList.add('hidden')
    }
    
    // Generate options
    this.generateOptions(question)
    
    // Hide explanation
    this.explanationContainerTarget.classList.add('hidden')
    this.showExplanation = false
    
    // Reset buttons
    this.checkButtonTarget.classList.remove('hidden')
    this.nextButtonTarget.classList.add('hidden')
    this.checkButtonTarget.disabled = true
    
    // Show question view, hide completed view
    this.questionViewTarget.classList.remove('hidden')
    this.completedViewTarget.classList.add('hidden')
  }

  generateOptions(question) {
    this.optionsContainerTarget.innerHTML = ''
    
    switch (question.type) {
      case 'multiple-choice':
        this.generateMultipleChoice(question)
        break
      case 'true-false':
        this.generateTrueFalse(question)
        break
      case 'multiple-answer':
        this.generateMultipleAnswer(question)
        break
      case 'code-completion':
      case 'short-answer':
        this.generateTextArea(question)
        break
    }
  }

  generateMultipleChoice(question) {
    question.options.forEach((option, index) => {
      const div = document.createElement('div')
      div.className = 'option-item'
      div.innerHTML = `
        <input type="radio" name="answer" value="${option}" id="option-${index}">
        <label for="option-${index}">${option}</label>
      `
      this.optionsContainerTarget.appendChild(div)
      
      const input = div.querySelector('input')
      input.addEventListener('change', () => {
        this.userAnswers[question.id] = option
        this.checkButtonTarget.disabled = false
      })
    })
  }

  generateTrueFalse(question) {
    const options = [
      { value: 'true', label: 'Verdadero' },
      { value: 'false', label: 'Falso' }
    ]
    
    options.forEach((option, index) => {
      const div = document.createElement('div')
      div.className = 'option-item'
      div.innerHTML = `
        <input type="radio" name="answer" value="${option.value}" id="option-${index}">
        <label for="option-${index}">${option.label}</label>
      `
      this.optionsContainerTarget.appendChild(div)
      
      const input = div.querySelector('input')
      input.addEventListener('change', () => {
        this.userAnswers[question.id] = option.value
        this.checkButtonTarget.disabled = false
      })
    })
  }

  generateMultipleAnswer(question) {
    this.userAnswers[question.id] = []
    
    question.options.forEach((option, index) => {
      const div = document.createElement('div')
      div.className = 'option-item'
      div.innerHTML = `
        <input type="checkbox" value="${option}" id="option-${index}">
        <label for="option-${index}">${option}</label>
      `
      this.optionsContainerTarget.appendChild(div)
      
      const input = div.querySelector('input')
      input.addEventListener('change', () => {
        if (input.checked) {
          this.userAnswers[question.id].push(option)
        } else {
          this.userAnswers[question.id] = this.userAnswers[question.id].filter(a => a !== option)
        }
        this.checkButtonTarget.disabled = this.userAnswers[question.id].length === 0
      })
    })
  }

  generateTextArea(question) {
    const textarea = document.createElement('textarea')
    textarea.className = 'answer-textarea'
    textarea.placeholder = question.type === 'code-completion' ? 'Escribe tu código aquí...' : 'Escribe tu respuesta aquí...'
    
    if (question.type === 'code-completion') {
      textarea.classList.add('code-textarea')
    }
    
    textarea.addEventListener('input', () => {
      this.userAnswers[question.id] = textarea.value
      this.checkButtonTarget.disabled = !textarea.value.trim()
    })
    
    this.optionsContainerTarget.appendChild(textarea)
  }

  async checkAnswer() {
    const question = this.questions[this.currentQuestionIndex]
    const userAnswer = this.userAnswers[question.id]
    
    if (!userAnswer) return
    
    try {
      const response = await fetch('/quiz/submit_answer', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          question_id: question.id,
          answer: userAnswer
        })
      })
      
      const data = await response.json()
      
      if (data.correct) {
        this.score++
      }
      
      this.showExplanationResult(data.correct, data.explanation, data.correct_answer)
      
    } catch (error) {
      console.error('Error submitting answer:', error)
      alert('Error al enviar la respuesta. Por favor, intenta de nuevo.')
    }
  }

  showExplanationResult(isCorrect, explanation, correctAnswer) {
    this.showExplanation = true
    
    // Update explanation container
    this.explanationContainerTarget.classList.remove('hidden')
    this.explanationContainerTarget.classList.add(isCorrect ? 'correct' : 'incorrect')
    
    // Update icon
    this.explanationIconTarget.textContent = isCorrect ? '✅' : '❌'
    
    // Update title
    this.explanationTitleTarget.textContent = isCorrect ? '¡Correcto!' : 'Incorrecto'
    this.explanationTitleTarget.classList.add(isCorrect ? 'correct' : 'incorrect')
    
    // Update explanation text
    this.explanationTextTarget.textContent = explanation
    
    // Show correct answer if incorrect
    if (!isCorrect) {
      this.correctAnswerContainerTarget.classList.remove('hidden')
      
      if (Array.isArray(correctAnswer)) {
        this.correctAnswerContentTarget.innerHTML = `
          <ul>
            ${correctAnswer.map(answer => `<li>${answer}</li>`).join('')}
          </ul>
        `
      } else {
        this.correctAnswerContentTarget.innerHTML = `<p>${correctAnswer}</p>`
      }
    } else {
      this.correctAnswerContainerTarget.classList.add('hidden')
    }
    
    // Update buttons
    this.checkButtonTarget.classList.add('hidden')
    this.nextButtonTarget.classList.remove('hidden')
    
    // Disable all inputs
    this.optionsContainerTarget.querySelectorAll('input, textarea').forEach(input => {
      input.disabled = true
    })
  }

  nextQuestion() {
    if (this.currentQuestionIndex < this.questions.length - 1) {
      this.currentQuestionIndex++
      this.displayQuestion()
    } else {
      this.showResults()
    }
  }

  async showResults() {
    try {
      const response = await fetch('/quiz/results', {
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })
      
      const data = await response.json()
      
      // Update category name
      const categories = {
        'sorting': 'Algoritmos de Ordenamiento',
        'searching': 'Algoritmos de Búsqueda',
        'data-structures': 'Estructuras de Datos',
        'complexity': 'Complejidad Algorítmica'
      }
      this.categoryNameTarget.textContent = categories[this.currentCategory]
      
      // Update score
      this.finalScoreTarget.textContent = `${data.score} / ${data.total}`
      this.finalPercentageTarget.textContent = data.percentage
      this.finalProgressBarTarget.style.width = `${data.percentage}%`
      
      // Update evaluation
      const evaluation = data.evaluation
      this.evaluationBadgeTarget.className = `evaluation-badge ${evaluation.color}`
      this.evaluationBadgeTarget.textContent = evaluation.level
      this.evaluationMessageTarget.textContent = evaluation.message
      
      // Show completed view
      this.questionViewTarget.classList.add('hidden')
      this.completedViewTarget.classList.remove('hidden')
      
    } catch (error) {
      console.error('Error loading results:', error)
      alert('Error al cargar los resultados.')
    }
  }

  cancelQuiz() {
    this.restartQuiz()
  }

  restartQuiz() {
    this.currentCategory = null
    this.questions = []
    this.currentQuestionIndex = 0
    this.userAnswers = {}
    this.score = 0
    this.showExplanation = false
    
    this.showCategories()
  }
}