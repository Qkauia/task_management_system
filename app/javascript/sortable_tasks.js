import Sortable from 'sortablejs';

document.addEventListener('turbo:load', () => {
  const normalTasksList = document.getElementById('normal-tasks');
  const importantTasksList = document.getElementById('important-tasks');

  // 初始化普通任務列表的拖曳
  if (normalTasksList && importantTasksList) {
    Sortable.create(normalTasksList, {
      group: 'tasks',
      animation: 150,
      onEnd: function (event) {
        // 處理排序更新
        const order = Array.from(normalTasksList.children).map((item, index) => {
          return { id: item.dataset.taskId, position: index + 1 };
        });

        fetch('/tasks/sort', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ order: order })
        }).then(response => {
          if (response.ok) {
            location.reload(); // 排序成功後重新加載頁面
          } else {
            alert('排序更新失敗');
          }
        }).catch(error => {
          console.error('更新排序時出錯:', error);
        });

        // 更新重要性
        const taskId = event.item.dataset.taskId;
        if (event.to === importantTasksList) {
          updateTaskImportance(taskId, true);
        }
      }
    });

    Sortable.create(importantTasksList, {
      group: 'tasks',
      animation: 150,
      onEnd: function (event) {
        const taskId = event.item.dataset.taskId;
        if (event.to === normalTasksList) {
          updateTaskImportance(taskId, false);
        }
      }
    });
  }

  function updateTaskImportance(taskId, isImportant) {
    if (!taskId) {
      console.error('任務 ID 無效:', taskId);
      alert('任務 ID 無效，無法更新任務狀態。');
      return;
    }

    fetch(`/tasks/${taskId}/update_importance`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ important: isImportant })
    }).then(response => {
      if (response.ok) {
        location.reload(); // 更新成功後重新加載頁面
      } else {
        alert('更新任務狀態失敗');
        console.error('更新失敗:', response);
      }
    }).catch(error => {
      console.error('更新任務狀態時出錯:', error);
      alert('發生錯誤，無法更新任務狀態。');
    });
  }
});
