import Swal from 'sweetalert2';

document.addEventListener('turbo:load', () => {
  const flashErrorsElement = document.getElementById('flash-errors');

  if (flashErrorsElement) {
    const errors = JSON.parse(flashErrorsElement.dataset.errors);

    if (errors.length > 0) {
      Swal.fire({
        icon: 'error',
        title: 'Oops...',
        html: "<ul style='text-align: left;'>" +
              errors.map(error => `<li>${error}</li>`).join('') +
              "</ul>",
        confirmButtonText: '了解'
      });
    }
  }
});
