// app/javascript/controllers/algorithm_visualizer.js

window.AlgorithmVisualizer = window.AlgorithmVisualizer || (function() {
  'use strict';

  let currentMergeArray = window._defaultArray || [];
  let currentQuickArray = window._defaultArray || [];

  let mergeSteps = [];
  let quickSteps = [];
  let currentMergeStep = 0;
  let currentQuickStep = 0;
  let mergeInterval = null;
  let quickInterval = null;
  let isInitialized = false;

  function getCSRFToken() {
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    return metaTag ? metaTag.getAttribute('content') : '';
  }

  function getTarget(name) {
    return document.querySelector(`[data-algorithm-target="${name}"]`);
  }

  function showTab(tabName) {
    const mergeSortTab = getTarget('mergeSortTab');
    const quickSortTab = getTarget('quickSortTab');
    const mergeSortContent = getTarget('mergeSortContent');
    const quickSortContent = getTarget('quickSortContent');

    if (!mergeSortTab || !quickSortTab || !mergeSortContent || !quickSortContent) return;

    mergeSortTab.className = tabName === 'merge-sort'
      ? 'flex-1 py-4 px-6 text-center font-semibold bg-blue-500 text-white transition-colors'
      : 'flex-1 py-4 px-6 text-center font-semibold bg-gray-200 text-gray-700 hover:bg-gray-300 transition-colors';

    quickSortTab.className = tabName === 'quick-sort'
      ? 'flex-1 py-4 px-6 text-center font-semibold bg-red-500 text-white transition-colors'
      : 'flex-1 py-4 px-6 text-center font-semibold bg-gray-200 text-gray-700 hover:bg-gray-300 transition-colors';

    mergeSortContent.classList.toggle('hidden', tabName !== 'merge-sort');
    quickSortContent.classList.toggle('hidden', tabName !== 'quick-sort');
  }

  function runMergeSort() {
    const runButton = getTarget('runMergeSort');
    if (!runButton) return;

    runButton.disabled = true;
    runButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Ejecutando...';

    fetch('/algorithms/merge_sort', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRFToken()
      },
      body: JSON.stringify({ array: currentMergeArray })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        mergeSteps = data.steps;
        currentMergeStep = 0;
        updateMergeStatus();
        const stepButton = getTarget('stepMergeSort');
        const stateElement = getTarget('mergeState');
        if (stepButton) stepButton.disabled = false;
        if (stateElement) stateElement.textContent = 'Ejecutando';

        mergeInterval = setInterval(() => {
          if (currentMergeStep < mergeSteps.length - 1) {
            stepMergeSort();
          } else {
            clearInterval(mergeInterval);
            if (stateElement) stateElement.textContent = 'Completado';
          }
        }, 1200);
      } else {
        alert('Error: ' + (data.error || 'Error desconocido'));
      }
    })
    .catch(error => alert('Error de conexión: ' + error.message))
    .finally(() => {
      runButton.disabled = false;
      runButton.innerHTML = '<i class="fas fa-play mr-2"></i>Ejecutar';
    });
  }

  function stepMergeSort() {
    if (currentMergeStep < mergeSteps.length - 1) {
      currentMergeStep++;
      updateMergeVisualization();
      updateMergeStatus();
    }
  }

  function resetMergeSort() {
    clearInterval(mergeInterval);
    currentMergeStep = 0;
    mergeSteps = [];
    const stepButton = getTarget('stepMergeSort');
    const stateElement = getTarget('mergeState');
    if (stepButton) stepButton.disabled = true;
    if (stateElement) stateElement.textContent = 'Detenido';
    updateMergeVisualization();
    updateMergeStatus();
  }

  function runQuickSort() {
    const runButton = getTarget('runQuickSort');
    if (!runButton) return;

    runButton.disabled = true;
    runButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Ejecutando...';

    fetch('/algorithms/quick_sort', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRFToken()
      },
      body: JSON.stringify({ array: currentQuickArray })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        quickSteps = data.steps;
        currentQuickStep = 0;
        updateQuickStatus();
        const stepButton = getTarget('stepQuickSort');
        const stateElement = getTarget('quickState');
        if (stepButton) stepButton.disabled = false;
        if (stateElement) stateElement.textContent = 'Ejecutando';

        quickInterval = setInterval(() => {
          if (currentQuickStep < quickSteps.length - 1) {
            stepQuickSort();
          } else {
            clearInterval(quickInterval);
            if (stateElement) stateElement.textContent = 'Completado';
          }
        }, 1000);
      }
    })
    .catch(error => console.error(error))
    .finally(() => {
      runButton.disabled = false;
      runButton.innerHTML = '<i class="fas fa-play mr-2"></i>Ejecutar';
    });
  }

  function stepQuickSort() {
    if (currentQuickStep < quickSteps.length - 1) {
      currentQuickStep++;
      updateQuickVisualization();
      updateQuickStatus();
    }
  }

  function resetQuickSort() {
    clearInterval(quickInterval);
    currentQuickStep = 0;
    quickSteps = [];
    const stepButton = getTarget('stepQuickSort');
    const stateElement = getTarget('quickState');
    if (stepButton) stepButton.disabled = true;
    if (stateElement) stateElement.textContent = 'Detenido';
    updateQuickVisualization();
    updateQuickStatus();
  }

  function generateNewArray(algorithm) {
    fetch('/algorithms/generate_array', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRFToken()
      },
      body: JSON.stringify({ size: 10, max_value: 100 })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        if (algorithm === 'merge') {
          currentMergeArray = data.array;
          resetMergeSort();
        } else {
          currentQuickArray = data.array;
          resetQuickSort();
        }
      }
    })
    .catch(console.error);
  }

  function updateMergeVisualization() {
    const container = getTarget('mergeArrayContainer');
    if (!container) return;

    const currentStep = mergeSteps[currentMergeStep] || {
      array: currentMergeArray, comparing: [], merging: [], sorted: []
    };

    container.innerHTML = '';

    currentStep.array.forEach((value, index) => {
      const element = document.createElement('div');
      element.className = 'flex items-end justify-center text-white font-bold text-sm rounded transition-all duration-300';
      element.style.width = '48px';
      element.style.height = Math.max(value * 0.8, 20) + 'px';
      element.innerHTML = `<span class="mb-1">${value}</span>`;

      if (currentStep.comparing.includes(index)) {
        element.className += ' bg-yellow-500 transform scale-105';
      } else if (currentStep.merging.includes(index)) {
        element.className += ' bg-purple-500 transform scale-105';
      } else if (currentStep.sorted.includes(index)) {
        element.className += ' bg-green-500';
      } else {
        element.className += ' bg-blue-500';
      }

      container.appendChild(element);
    });
  }

  function updateQuickVisualization() {
    const container = getTarget('quickArrayContainer');
    if (!container) return;

    const currentStep = quickSteps[currentQuickStep] || {
      array: currentQuickArray, comparing: [], pivot: null, sorted: []
    };

    container.innerHTML = '';

    currentStep.array.forEach((value, index) => {
      const element = document.createElement('div');
      element.className = 'flex items-end justify-center text-white font-bold text-sm rounded transition-all duration-300';
      element.style.width = '48px';
      element.style.height = Math.max(value * 0.8, 20) + 'px';
      element.innerHTML = `<span class="mb-1">${value}</span>`;

      if (currentStep.pivot === index) {
        element.className += ' bg-red-500 transform scale-110';
      } else if (currentStep.comparing.includes(index)) {
        element.className += ' bg-yellow-500 transform scale-105';
      } else if (currentStep.sorted.includes(index)) {
        element.className += ' bg-green-500';
      } else {
        element.className += ' bg-blue-500';
      }

      container.appendChild(element);
    });
  }

  function updateMergeStatus() {
    const stepElement = getTarget('mergeStep');
    const totalStepsElement = getTarget('mergeTotalSteps');
    const descriptionElement = getTarget('mergeDescription');

    if (stepElement) stepElement.textContent = currentMergeStep;
    if (totalStepsElement) totalStepsElement.textContent = mergeSteps.length > 0 ? mergeSteps.length - 1 : 0;

    if (mergeSteps[currentMergeStep] && descriptionElement) {
      descriptionElement.textContent = mergeSteps[currentMergeStep].description;
    }
  }

  function updateQuickStatus() {
    const stepElement = getTarget('quickStep');
    const totalStepsElement = getTarget('quickTotalSteps');
    const descriptionElement = getTarget('quickDescription');

    if (stepElement) stepElement.textContent = currentQuickStep;
    if (totalStepsElement) totalStepsElement.textContent = quickSteps.length > 0 ? quickSteps.length - 1 : 0;

    if (quickSteps[currentQuickStep] && descriptionElement) {
      descriptionElement.textContent = quickSteps[currentQuickStep].description;
    }
  }

  function cleanup() {
    clearInterval(mergeInterval);
    clearInterval(quickInterval);
  }

  function init() {
    if (isInitialized) {
      cleanup();
    }

    document.querySelector('[data-algorithm-target="mergeSortTab"]')?.addEventListener('click', () => showTab('merge-sort'));
    document.querySelector('[data-algorithm-target="quickSortTab"]')?.addEventListener('click', () => showTab('quick-sort'));
    document.querySelector('[data-algorithm-target="runMergeSort"]')?.addEventListener('click', runMergeSort);
    document.querySelector('[data-algorithm-target="stepMergeSort"]')?.addEventListener('click', stepMergeSort);
    document.querySelector('[data-algorithm-target="resetMergeSort"]')?.addEventListener('click', resetMergeSort);
    document.querySelector('[data-algorithm-target="generateMergeArray"]')?.addEventListener('click', () => generateNewArray('merge'));
    document.querySelector('[data-algorithm-target="runQuickSort"]')?.addEventListener('click', runQuickSort);
    document.querySelector('[data-algorithm-target="stepQuickSort"]')?.addEventListener('click', stepQuickSort);
    document.querySelector('[data-algorithm-target="resetQuickSort"]')?.addEventListener('click', resetQuickSort);
    document.querySelector('[data-algorithm-target="generateQuickArray"]')?.addEventListener('click', () => generateNewArray('quick'));

    updateMergeVisualization();
    updateQuickVisualization();

    isInitialized = true;
  }

  return {
    init,
    cleanup
  };
})();

document.addEventListener('turbo:load', () => {
  window.AlgorithmVisualizer?.init();
});

document.addEventListener('turbo:before-visit', () => {
  window.AlgorithmVisualizer?.cleanup();
});
