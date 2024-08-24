import Swal from 'sweetalert2';

document.addEventListener('turbo:load', () => {
  const flashMessageElement = document.querySelector('#flash-message');

  if (flashMessageElement && flashMessageElement.dataset.message) {
    const messageType = flashMessageElement.dataset.type;
    const messageText = flashMessageElement.dataset.message;

    Swal.fire({
      icon: messageType,
      title: messageType === 'success' ? '成功' : '錯誤',
      text: messageText,
      showConfirmButton: true,
      confirmButtonText: '確定'
    });
  }
});


