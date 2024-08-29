import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import Swal from 'sweetalert2';

document.addEventListener('turbo:load', function () {
  function showCalendar(event) {
    event.preventDefault();

    Swal.fire({
      title: '個人(分享)任務日曆',
      html: `
        <div id="calendar" style="min-height: 400px; opacity: 0; transition: opacity 0.5s;"></div>
        <button id="closeButton" class="swal2-close-btn btn btn-secondary mt-3">Close</button>
      `,
      width: '100%',
      showConfirmButton: false,
      didOpen: () => {
        const calendarEl = document.getElementById('calendar');
        if (calendarEl) {
          setTimeout(() => {
            const isSmallScreen = window.innerWidth < 768;
            const calendar = new Calendar(calendarEl, {
              plugins: [dayGridPlugin],
              initialView: isSmallScreen ? 'dayGridDay' : 'dayGridMonth', // 小螢幕顯示每日視圖
              events: '/tasks/personal.json',
              headerToolbar: {
                left: 'prev,next',
                center: 'title',
                right: isSmallScreen ? 'dayGridDay' : 'dayGridMonth,dayGridWeek,dayGridDay', // 小螢幕上只顯示日視圖
              },
              height: 'auto',
              eventContent: function (info) {
                const truncatedTitle = info.event.title.length > 20 
                  ? info.event.title.substring(0, 20) + '...'
                  : info.event.title;

                return {
                  html: `<div class="task-event" style="margin: 5px 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">☉ ${truncatedTitle}</div>`,
                };
              },
              eventDidMount: function (info) {
                info.el.style.fontSize = isSmallScreen ? '12px' : '14px';
              },
              eventClick: function (info) {
                info.jsEvent.preventDefault();
                if (info.event.url) {
                  window.location.href = info.event.url;
                }
              },
            });
            calendar.render();

            calendarEl.style.opacity = 1;
          }, 1000);
        }

        document.getElementById('closeButton').addEventListener('click', () => {
          Swal.close();
        });
      },
    });
  }

  document.getElementById('showCalendarButton').addEventListener('click', showCalendar);
});
