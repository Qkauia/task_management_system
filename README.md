# Task Manager Application

## Project Overview
This project is a task management system that allows users to create, manage, and categorize their tasks, with support for group functionality and a notification system.

## Tech Stack
- Ruby 3.2.0
- Rails 7.1.3
- PostgreSQL

## Installation Guide
1. Clone the project locally:
    ```bash
    git clone git@github.com:Qkauia/task_management_system.git
    cd task-manager
    ```
2. Install dependencies:
    ```bash
    bundle install
    yarn install
    ```
3. Set up the database:
    ```bash
    rails db:create
    rails db:migrate
    ```
4. Seed the database:
    ```bash
    rails db:seed
    ```
5. Start the server:
    ```bash
    bin/dev
    ```

## Database Structure

### Extensions
This project uses the following PostgreSQL extension:
- `plpgsql`: Procedural language support for PostgreSQL.

### Tables

#### `groups`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `id`       | `bigint`            | Primary key.                 |
| `name`     | `string`           | Group name.                  |
| `user_id`  | `integer`          | Creator (Group Leader).      |
| `deleted_at` | `datetime`       | Soft delete timestamp.       |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

#### `group_users`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `group_id` | `bigint` (foreign key) | References the `groups` table. |
| `user_id`  | `bigint` (foreign key) | References the `users` table. |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

**Indexes:**
- `index_group_users_on_group_id`
- `index_group_users_on_user_id`

**Associations:**
- `belongs_to :group`
- `belongs_to :user`

#### `group_tasks`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `group_id` | `bigint` (foreign key) | References the `groups` table. |
| `task_id`  | `bigint` (foreign key) | References the `tasks` table. |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

**Indexes:**
- `index_group_tasks_on_group_id`
- `index_group_tasks_on_task_id`

**Associations:**
- `belongs_to :group`
- `belongs_to :task`

#### `tasks`
| Column       | Type                     | Description                                                      |
|--------------|--------------------------|------------------------------------------------------------------|
| `title`      | `string`                 | Task title.                                                      |
| `content`    | `text`                   | Task content.                                                    |
| `start_time` | `datetime`               | Start time for the task.                                         |
| `end_time`   | `datetime`               | End time for the task.                                           |
| `priority`   | `integer` (default: 1, not null) | Task priority (1: low, 2: medium, 3: high).                     |
| `status`     | `integer` (default: 1, not null) | Task status (1: pending, 2: in progress, 3: completed).         |
| `position`   | `integer`                | Task's position for sorting or ordering purposes.                 |
| `important`  | `boolean`                | Indicates if the task is marked as important (true: important, false: not important). |
| `user_id`    | `bigint` (foreign key)   | References the `users` table.                                     |
| `deleted_at` | `datetime`               | Soft delete timestamp.                                            |
| `created_at` | `datetime`               | Timestamp when the record was created.                            |
| `updated_at` | `datetime`               | Timestamp when the record was last updated.                       |

**Indexes:**
- `index_tasks_on_deleted_at`
- `index_tasks_on_user_id`

#### `users`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `email`    | `string` (default: "", not null) | User email address (must be unique). |
| `password_hash` | `string` (not null) | Hashed password.            |
| `password_salt` | `string` (not null) | Password salt.              |
| `role`     | `string`           | User role (e.g., admin, regular user). |
| `avatar`   | `string`           | Path to user avatar.         |
| `deleted_at` | `datetime`       | Soft delete timestamp.       |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

**Indexes:**
- `index_users_on_deleted_at`
- `index_users_on_email` (unique)

### Foreign Keys
- `group_tasks`: `group_id`, `task_id`
- `group_users`: `group_id`, `user_id`
- `tasks`: `user_id`
- `notifications`: `user_id`, `task_id`
- `task_tags`: `task_id`, `tag_id`
- `task_users`: `task_id`, `user_id`


## 部屬流程

首先 Fly.io 支援 Dockerfile 部屬，所以我先建立 Dockerfile 和 Docker Compose，並嘗試在 Docker 中運行。

1. **註冊 Fly.io 帳號並登入**：
   - 使用 `$flyctl auth login` 註冊並登入 Fly.io 帳號，並且進行身份認證（需要提供信用卡信息）。

2. **初始化應用**：
   - 使用 `$flyctl launch` 進入初始化設定。
     - **應用程式名**：Fly.io 會根據當前目錄名稱自動綁定應用名稱，也可以手動修改。
     - **部屬區域**：Fly.io 會根據位置推薦最近的伺服器區域（效能可能依據距離決定）。
     - **PostgreSQL 資料庫配置**：透過 Fly.io 創建並綁定資料庫，可客製選擇資料庫規格。
     - **Redis 配置（可選）**：可選擇是否配置 Redis。

   - **Fly.io 會生成配置文件，其中 `fly.toml` 非常重要**：
     - `fly.toml` 這個文件會根據初始化過程生成，但部分內容需要手動調整。
     - 例如：
       ```toml
       app = 'taskmanagementsystem'  # Fly.io 上應用的名稱，這是應用的唯一標識符
       primary_region = 'nrt'  # 部署應用的主要區域
       console_command = '/rails/bin/rails console'  # 預設的 Rails 控制台命令

       [build]
         dockerfile = "./Dockerfile"  # 指定 Dockerfile 的路徑，用於構建應用的 Docker 映像

       [deploy]
         release_command = './bin/rails db:prepare'  # 部署時執行的命令，資料庫遷移

       [http_service]
         internal_port = 3000  # 應用程序內部使用的端口，這裡是 Rails 伺服器的默認端口 3000
         force_https = true  # 強制使用 HTTPS 來訪問應用，確保安全性
         auto_stop_machines = 'stop'  # 當應用空閒時自動停止機器，以節省資源和省錢
         auto_start_machines = true  # 當有請求進來時，自動啟動機器
         min_machines_running = 0  # 設置最少運行的機器數量，這裡設置為 0，表示在無請求時機器可以全部停止
         processes = ['app']  # 定義應用程序的進程名稱，通常用於標記或區分不同的服務

       [[vm]]
         memory = '1gb'  # 分配給每個 VM 的內存大小，這裡設置為 1GB
         cpu_kind = 'shared'  # 使用共享的 CPU 類型，適合大多數一般用途的應用
         cpus = 1  # 分配給每個 VM 的 CPU 核心數量，這裡設置為 1 核

       [[statics]]
         guest_path = '/rails/public'  # 指定應用程序中靜態文件的路徑，通常是 Rails 的 public 資料夾
         url_prefix = '/'  # 靜態資源的 URL 前綴，這裡設置為根目錄
       ```

   - **設置環境變數給 Fly.io**：
     - 例如設置 `AWS_ACCESS_KEY_ID` 和 `SECRET_KEY_BASE` 等，使用 Fly.io 的指令設定：
     - 示例指令：`$flyctl secrets set AWS_ACCESS_KEY_ID=hello SECRET_KEY_BASE=$(bin/rails secret) ...`

3. **部屬應用**：
   - 使用 `$fly deploy` 進行部屬。
     - 如果部屬失敗，會顯示錯誤訊息，例如缺少套件或是變數等。
     - 根據錯誤訊息進行更改並重新部屬。
     - 部屬成功後會顯示應用程式的 domain。

4. **檢查應用狀態**：
   - 部屬成功後，可以進入應用的 domain 檢查是否有異常。
   - 使用 `$fly logs` 查看實時日誌，或使用 `$fly status` 查看應用的運行狀態。
