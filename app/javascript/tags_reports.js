import Swal from 'sweetalert2';
import Chart from 'chart.js/auto';

document.addEventListener('turbo:load', () => {
  const showAlertButton = document.getElementById('show-chart-button');

  if (showAlertButton) {
    showAlertButton.addEventListener('click', () => {
      let chartType = 'bar'; // 預設為柱狀圖

      Swal.fire({
        title: '標籤使用率',
        html: `
          <div style="position: relative; height: 500px; width: 100%;">
            <canvas id="tagUsageChart"></canvas>
          </div>
          <div style="text-align: center; margin-top: 10px;">
            <button id="toggleChartType" class="btn btn-secondary">切換為圓餅圖</button>
          </div>
        `,
        width: '1500px',
        showConfirmButton: true,
        didOpen: () => {
          const ctx = document.getElementById('tagUsageChart').getContext('2d');
          let chartInstance;

          // 用來載入資料並繪製圖表的函數
          const fetchDataAndRenderChart = (type) => {
            fetch('/reports/tag_usage.json')
              .then(response => response.json())
              .then(data => {
                // 如果已經有圖表實例，先銷毀它以避免重疊
                if (chartInstance) {
                  chartInstance.destroy();
                }

                chartInstance = new Chart(ctx, {
                  type: type,
                  data: {
                    labels: Object.keys(data),
                    datasets: [{
                      label: '標籤使用次數',
                      data: Object.values(data),
                      backgroundColor: type === 'pie' ? [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 159, 64, 0.7)'
                      ] : 'rgba(54, 162, 235, 0.7)',
                      borderColor: type === 'pie' ? [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                      ] : 'rgba(54, 162, 235, 1)',
                      borderWidth: 1
                    }]
                  },
                  options: {
                    responsive: true,
                    maintainAspectRatio: false, // 設定為 false 以允許自由調整大小
                    scales: type === 'bar' ? {
                      y: {
                        beginAtZero: true
                      }
                    } : {}
                  }
                });
              })
              .catch(error => {
                console.error('無法載入標籤使用數據:', error);
                Swal.fire({
                  icon: 'error',
                  title: '錯誤',
                  text: '無法載入標籤使用數據，請稍後再試。'
                });
              });
          };

          // 初次載入預設為柱狀圖
          fetchDataAndRenderChart(chartType);

          // 切換圖表類型的按鈕
          document.getElementById('toggleChartType').addEventListener('click', () => {
            chartType = chartType === 'bar' ? 'pie' : 'bar'; // 在柱狀圖和圓餅圖之間切換
            const buttonText = chartType === 'bar' ? '切換為圓餅圖' : '切換為柱狀圖';
            document.getElementById('toggleChartType').textContent = buttonText;
            fetchDataAndRenderChart(chartType); // 重新載入並渲染圖表
          });
        }
      });
    });
  }
});
