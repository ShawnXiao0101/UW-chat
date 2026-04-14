# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KamaChat is a distributed WeChat-like instant messaging system with a Go backend and Vue 3 frontend. The backend is a monolithic Go service (module: `kama_chat_server`) serving HTTPS/WebSocket endpoints. The frontend is a Vue 3 SPA in `web/chat-server/`.

## Backend Commands

```bash
# Run the server
cd cmd/kama_chat_server && go run main.go

# Build the binary
go build -o cmd/kama_chat_server/kama_chat_backend ./cmd/kama_chat_server/

# Run tests (in a specific test package)
go test ./test/dao/...
go test ./test/zlog/...
go test ./test/config/...

# Download dependencies
go mod tidy
```

## Frontend Commands

```bash
cd web/chat-server

# Install dependencies
yarn install

# Start dev server
yarn serve

# Build for production
yarn build

# Lint
yarn lint
```

## Configuration

The backend reads from `configs/config_local.toml` (not committed — copy from `configs/config.toml`). The config path is hardcoded in `internal/config/config.go` to `/root/project/KamaChat/configs/config_local.toml` for server deployment. For local development, update that path or use the commented-out local path block in the same file.

Key config sections: `[mainConfig]` (host/port), `[mysqlConfig]`, `[redisConfig]`, `[kafkaConfig]`, `[authCodeConfig]` (Alibaba Cloud SMS), `[staticSrcConfig]` (file storage paths).

## Architecture

### Backend Layer Structure

- `cmd/kama_chat_server/main.go` — entry point; initializes Kafka/channel chat server, starts TLS HTTP server, handles graceful shutdown (deletes all Redis keys on exit)
- `internal/https_server/https_server.go` — Gin router setup with all REST routes and the `/wss` WebSocket endpoint; enforces TLS redirect via `pkg/ssl`
- `api/v1/` — HTTP controllers; `controller.go` provides `JsonBack()` helper used by all handlers (codes: 200=ok, 400=client error, 500=server error)
- `internal/service/` — business logic split into: `chat/` (WebSocket hub), `kafka/` (Kafka producer/consumer), `redis/` (Redis helpers), `aes/` (encryption), `gorm/` (DB query helpers), `sms/` (Alibaba Cloud SMS)
- `internal/dao/gorm.go` — initializes GORM with MySQL via Unix socket and runs `AutoMigrate` for all models on startup
- `internal/model/` — GORM models: `UserInfo`, `GroupInfo`, `UserContact`, `Session`, `ContactApply`, `Message`
- `internal/dto/request/` and `internal/dto/respond/` — request/response structs for API and WebSocket messages
- `internal/config/config.go` — TOML config loader (singleton via `GetConfig()`)
- `pkg/` — shared utilities: `constants/`, `enum/` (typed enums for contact/group/message/user states), `util/`, `zlog/` (zap-based logger with lumberjack rotation), `ssl/`

### WebSocket / Chat Message Flow

Two modes controlled by `kafkaConfig.messageMode` in config:

1. **`channel` mode** (default): `chat.ChatServer` is a pure Go channel-based hub (`internal/service/chat/server.go`). The `Server` struct holds a `Clients` map (uuid→Client), and three channels: `Login`, `Logout`, `Transmit`. Messages arrive via WebSocket, are put on `Transmit`, and the server loop dispatches to recipients.

2. **`kafka` mode**: `chat.KafkaChatServer` uses Kafka topics (`login`, `logout`, `chat_message`) as the message bus instead of Go channels.

The `Client` struct (`internal/service/chat/client.go`) manages one WebSocket connection — it reads from the socket and writes via a `SendBack` channel.

### Message Routing

The server distinguishes recipients by UUID prefix:
- `U...` = user (direct message)
- `G...` = group (fan-out to all group members)

Messages are persisted to MySQL via GORM and cached in Redis with key patterns:
- `message_list_{sendId}_{receiveId}` for DMs
- `group_messagelist_{groupId}` for group chats

Redis cache TTL is `REDIS_TIMEOUT` minutes (currently 1 minute per `pkg/constants/constants.go`).

### Frontend Structure

Vue 3 + Vue Router + Vuex + Element Plus. Views are organized under `web/chat-server/src/views/`:
- `access/` — login/register pages
- `chat/` — main chat interface (single/group chats)
- `manager/` — admin management panel

The frontend communicates with the backend over HTTPS REST and a single `wss://` WebSocket connection.
