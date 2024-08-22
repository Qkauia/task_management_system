import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import Swal from 'sweetalert2';

document.addEventListener('turbo:load', function () { // 改成 turbo:load
  function showCalendar(event) {
    event.preventDefault();

    Swal.fire({
      title: '個人(分享)任務日曆',
      html: `
        <div id="calendar" style="min-height: 400px; opacity: 0; transition: opacity 0.5s;"></div>
        <button id="closeButton" class="swal2-close-btn btn btn-secondary mt-3">Close</button>
      `,
      width: '90%',
      showConfirmButton: false,
      didOpen: () => {
        const calendarEl = document.getElementById('calendar');
        if (calendarEl) {
          setTimeout(() => {
            const calendar = new Calendar(calendarEl, {
              plugins: [dayGridPlugin],
              initialView: 'dayGridMonth',
              events: '/tasks/personal.json',
              headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,dayGridWeek,dayGridDay',
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
