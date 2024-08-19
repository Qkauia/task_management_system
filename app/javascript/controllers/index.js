import { application } from "./application"

import TagButtonsController from "./tag_buttons_controller";
application.register("tag-buttons", TagButtonsController);

import TaskTimeController from "./task_time_controller";
application.register("task-time", TaskTimeController);
