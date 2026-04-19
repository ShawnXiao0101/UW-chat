# ============================================================
# Stage 1: Builder
# 使用完整的 Go 镜像编译，产物复制到 Stage 2，不把编译工具链带入最终镜像
# ============================================================
FROM golang:1.20-alpine AS builder

# 安装 git（部分 go module 需要）
RUN apk add --no-cache git

WORKDIR /build

# 先只复制依赖文件，利用 Docker layer 缓存：
# 只要 go.mod/go.sum 没变，这一层就不会重新 go mod download
COPY go.mod go.sum ./
RUN go mod download

# 再复制源代码
COPY . .

# 确保 static 子目录存在（它们被 .gitignore 排除，CI checkout 后可能缺失）
RUN mkdir -p static/avatars static/files

# 编译：
#   CGO_ENABLED=0  → 静态链接，不依赖 libc，可在 alpine/scratch 上跑
#   GOOS=linux     → 交叉编译为 Linux 二进制（开发机可能是 macOS）
#   -trimpath      → 去掉源码路径，减小二进制体积
#   -ldflags "-s -w" → 去掉 debug 符号，进一步减小体积
RUN CGO_ENABLED=0 GOOS=linux go build \
    -trimpath \
    -ldflags "-s -w" \
    -o kama_chat_backend \
    ./cmd/kama_chat_server/

# ============================================================
# Stage 2: Runtime
# 只包含运行时需要的最小内容，最终镜像只有 ~30MB
# ============================================================
FROM alpine:3.19

# 安装 ca-certificates（HTTPS 客户端请求需要）和 tzdata（时区）
RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# 从 builder 阶段复制编译好的二进制
COPY --from=builder /build/kama_chat_backend .

# 复制运行时需要的文件
COPY --from=builder /build/pkg/ssl   ./pkg/ssl
COPY --from=builder /build/static    ./static
COPY --from=builder /build/configs   ./configs

# 创建日志目录
RUN mkdir -p /app/logs

# 暴露端口（与 config 里的 port 一致）
EXPOSE 8000

# CONFIG_PATH 告诉程序去哪里读配置文件
# docker-compose 会用 -e CONFIG_PATH=... 覆盖这个值
ENV CONFIG_PATH=/app/configs/config_docker.toml

CMD ["./kama_chat_backend"]
