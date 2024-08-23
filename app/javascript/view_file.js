import Swal from 'sweetalert2';

document.addEventListener('turbo:load', () => {
  const viewFileButton = document.getElementById('view-file-button');
  
  if (viewFileButton) {
    viewFileButton.addEventListener('click', () => {
      const fileType = viewFileButton.dataset.fileType;
      const fileUrl = viewFileButton.dataset.fileUrl;

      if (fileType.startsWith('image')) {
        Swal.fire({
          title: '檢視檔案',
          html: `<img src="${fileUrl}" style="max-width: 100%; max-height: 400px;" alt="檔案內容">`,
          showCloseButton: true,
          focusConfirm: false,
          confirmButtonText: '關閉',
        });
      } else if (fileType === 'application/pdf') {
        Swal.fire({
          title: '檢視 PDF 檔案',
          html: `<iframe src="${fileUrl}" width="100%" height="600px" style="border:none;"></iframe>`,
          showCloseButton: true,
          focusConfirm: false,
          confirmButtonText: '關閉',
        });
      } else {
        Swal.fire({
          title: '無法預覽此檔案類型',
          text: '僅支援圖片和 PDF 檔案的預覽。',
          icon: 'warning',
          confirmButtonText: '關閉',
        });
      }
    });
  }
});
