## QTakes
[點擊進入網站 🌐](https://taskmanagementsystem.fly.dev/zh-TW/)

# Project Overview

該專案是一個任務管理系統，允許使用者建立、管理和分類他們的任務，並支援群組功能和通知系統。

### 主要功能

- **使用者管理**：
  - 註冊、登入和登出
  - 上傳大頭照
  - 更改密碼
  - **管理員角色**：
    - 搜尋使用者
    - 更改使用者權限
    - 刪除使用者

- **上傳檔案**：
  - 支援 Amazon S3

- **任務管理**：
  - 任務搜尋、篩選與排列
  - 查看標記使用量（圖表）
  - 任務分享功能：
    - 分享給使用者
    - 分享至群組
  - 任務自動排程至日曆顯示
  - 任務列表介面支援拖放操作
  - 任務到期通知

- **介面語言支援**：
  - 中文/英文
  - RWD 響應式設計

### 使用技術

#### 前端技術

- **Bootstrap**
- **Stimulus**

#### 後端技術

- **Ruby**
- **Ruby on Rails**

#### 部署和執行環境

- **Fly.io**
- **AWS**

#### 版本控制和代碼存儲

- **Git**
- **GitHub**

#### 資料庫

- **PostgreSQL**

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
此專案使用以下 PostgreSQL 擴充功能：
- `plpgsql`：支援 PostgreSQL 的程序化語言。

### Tables

#### `groups`
| 欄位名稱    | 資料類型  | 說明                                |
|-------------|-----------|-------------------------------------|
| `id`        | `bigint`  | 主鍵。                              |
| `name`      | `string`  | 群組名稱。                          |
| `user_id`   | `integer` | 建立者（群組領袖）。                |
| `deleted_at`| `datetime`| 軟刪除時間戳記。                    |
| `created_at`| `datetime`| 記錄建立的時間戳記。                |
| `updated_at`| `datetime`| 記錄最後更新的時間戳記。            |

#### `group_users`
| 欄位名稱    | 資料類型                  | 說明                                |
|-------------|---------------------------|-------------------------------------|
| `group_id`  | `bigint` (外鍵)           | 參考 `groups` 表。                  |
| `user_id`   | `bigint` (外鍵)           | 參考 `users` 表。                   |
| `created_at`| `datetime`                | 記錄建立的時間戳記。                |
| `updated_at`| `datetime`                | 記錄最後更新的時間戳記。            |

**索引:**
- `index_group_users_on_group_id`
- `index_group_users_on_user_id`

**關聯:**
- `belongs_to :group`
- `belongs_to :user`

#### `group_tasks`
| 欄位名稱    | 資料類型                  | 說明                                |
|-------------|---------------------------|-------------------------------------|
| `group_id`  | `bigint` (外鍵)           | 參考 `groups` 表。                  |
| `task_id`   | `bigint` (外鍵)           | 參考 `tasks` 表。                   |
| `created_at`| `datetime`                | 記錄建立的時間戳記。                |
| `updated_at`| `datetime`                | 記錄最後更新的時間戳記。            |

**索引:**
- `index_group_tasks_on_group_id`
- `index_group_tasks_on_task_id`

**關聯:**
- `belongs_to :group`
- `belongs_to :task`

#### `tasks`
| 欄位名稱    | 資料類型                  | 說明                                |
|-------------|---------------------------|-------------------------------------|
| `title`     | `string`                  | 任務標題。                          |
| `content`   | `text`                    | 任務內容。                          |
| `start_time`| `datetime`                | 任務開始時間。                      |
| `end_time`  | `datetime`                | 任務結束時間。                      |
| `priority`  | `integer` (預設值: 1, 不可為空) | 任務優先級 (1: 低, 2: 中, 3: 高)。 |
| `status`    | `integer` (預設值: 1, 不可為空) | 任務狀態 (1: 待處理, 2: 進行中, 3: 已完成)。 |
| `position`  | `integer`                 | 任務排序位置。                      |
| `important` | `boolean`                 | 是否標記為重要任務 (true: 重要, false: 不重要)。|
| `user_id`   | `bigint` (外鍵)           | 參考 `users` 表。                   |
| `deleted_at`| `datetime`                | 軟刪除時間戳記。                    |
| `created_at`| `datetime`                | 記錄建立的時間戳記。                |
| `updated_at`| `datetime`                | 記錄最後更新的時間戳記。            |

**索引:**
- `index_tasks_on_deleted_at`
- `index_tasks_on_user_id`

#### `users`
| 欄位名稱    | 資料類型                  | 說明                                |
|-------------|---------------------------|-------------------------------------|
| `email`     | `string` (預設值: "", 不可為空) | 使用者電子郵件地址 (必須唯一)。    |
| `password_hash` | `string` (不可為空)    | 密碼的哈希值。                      |
| `password_salt` | `string` (不可為空)    | 密碼鹽值。                          |
| `role`      | `string`                  | 使用者角色 (例如：管理員、普通用戶)。|
| `avatar`    | `string`                  | 使用者頭像的路徑。                  |
| `deleted_at`| `datetime`                | 軟刪除時間戳記。                    |
| `created_at`| `datetime`                | 記錄建立的時間戳記。                |
| `updated_at`| `datetime`                | 記錄最後更新的時間戳記。            |

**索引:**
- `index_users_on_deleted_at`
- `index_users_on_email` (唯一)

### 外鍵
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
