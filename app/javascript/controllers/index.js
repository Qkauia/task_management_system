import { application } from "./application"

import TagButtonsController from "./tag_buttons_controller";
application.register("tag-buttons", TagButtonsController);

import UserButtonsController from "./user_buttons_controller";
application.register("user-buttons", UserButtonsController);

import GroupButtonsController from "./group_buttons_controller";
application.register("group-buttons", GroupButtonsController);
