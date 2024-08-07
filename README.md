# Task Manager Application

## Table Schema

### users
| Column                 | Data Type         | Description                                |
|------------------------|-------------------|--------------------------------------------|
| email                  | string            | User's email address, not null, unique     |
| encrypted_password     | string            | User's encrypted password, not null        |
| reset_password_token   | string            | Token for resetting password, unique       |
| reset_password_sent_at | datetime          | Timestamp when reset password email sent   |
| remember_created_at    | datetime          | Timestamp when remember me was set         |
| created_at             | datetime          | Record creation timestamp, not null        |
| updated_at             | datetime          | Record last updated timestamp, not null    |

### tasks
| Column     | Data Type | Description                      |
|------------|-----------|----------------------------------|
| title      | string    | Title of the task                |
| content    | text      | Content or description of the task |
| start_time | datetime  | Start time of the task           |
| end_time   | datetime  | End time of the task             |
| priority   | integer   | Priority of the task             |
| status     | integer   | Status of the task               |
| user_id    | bigint    | ID of the user who created the task, not null |
| created_at | datetime  | Record creation timestamp, not null |
| updated_at | datetime  | Record last updated timestamp, not null |

### tags
| Column     | Data Type | Description                      |
|------------|-----------|----------------------------------|
| name       | string    | Name of the tag                  |
| created_at | datetime  | Record creation timestamp, not null |
| updated_at | datetime  | Record last updated timestamp, not null |

### task_tags
| Column     | Data Type | Description                      |
|------------|-----------|----------------------------------|
| task_id    | bigint    | ID of the associated task, not null |
| tag_id     | bigint    | ID of the associated tag, not null |
| created_at | datetime  | Record creation timestamp, not null |
| updated_at | datetime  | Record last updated timestamp, not null |

### Indexes
- **users**
  - `index_users_on_email` (unique)
  - `index_users_on_reset_password_token` (unique)

- **tasks**
  - `index_tasks_on_user_id`

- **task_tags**
  - `index_task_tags_on_tag_id`
  - `index_task_tags_on_task_id`

### Foreign Keys
- **task_tags**
  - `tag_id` references `tags`
  - `task_id` references `tasks`

- **tasks**
  - `user_id` references `users`
