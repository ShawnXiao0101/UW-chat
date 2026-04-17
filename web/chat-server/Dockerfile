# ============================================================
# Stage 1: Builder — 用 Node 编译 Vue 项目
# ============================================================
FROM node:18-alpine AS builder

WORKDIR /app

# 先复制依赖文件，利用 layer 缓存
# yarn.lock 存在时用 --frozen-lockfile 保证版本精确可复现
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# 再复制源代码并构建
COPY . .
RUN yarn build
# 产物输出到 /app/dist

# ============================================================
# Stage 2: Runtime — 用 nginx 只托管静态文件
# ============================================================
FROM nginx:1.25-alpine

# 删除 nginx 默认页面
RUN rm -rf /usr/share/nginx/html/*

# 把 Vue 编译产物复制进来
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制我们自定义的 nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
