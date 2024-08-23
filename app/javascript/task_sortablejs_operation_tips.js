import Swal from 'sweetalert2';

document.addEventListener('turbo:load', () => {
  // 檢查 localStorage 中是否已經顯示過提示
  if (!localStorage.getItem('dragHintShown')) {
    if (
      window.location.pathname === '/' ||
      window.location.pathname.includes('/tasks/personal') || 
      window.location.pathname.includes('/group_tasks')
    ) {
      console.log('即將顯示提示');
      Swal.fire({
        title: '偷偷告訴你',
        text: '你可以把所有任務拖移到重要任務表單!',
        icon: 'info',
        confirmButtonText: '我明白了'
      }).then(() => {
        // 設定 localStorage 表示提示已顯示
        localStorage.setItem('dragHintShown', 'true');
      });
    }
  }
});
