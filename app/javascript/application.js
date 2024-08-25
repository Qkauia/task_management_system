require("@hotwired/turbo-rails");
require("./controllers");
const $ = require('jquery');
window.$ = $;
window.jQuery = $;
require('../assets/stylesheets/application.css');


require("bootstrap");
require("bootstrap/dist/css/bootstrap.min.css");
require("flatpickr/dist/flatpickr.min.css");
require('select2');
require('select2/dist/css/select2.css');
require("chart.js/auto");

require('./select2_flatpickr');
require('./show_calendar');
require('./sortable_tasks');
require('./tags_reports');
require('./task_sortablejs_operation_tips');
require('./view_file');
require('./flash_message');
require('./error_any');
