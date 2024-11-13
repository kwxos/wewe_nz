FROM cooderl/wewe-rss-sqlite:latest

RUN apk update && \
    apk add --no-cache wget bash

# 将工作目录设为 /opt/app，而不是 /app
WORKDIR /opt/app

# 复制脚本和其他文件到 /opt/app
COPY docker-bootstrap.sh /opt/app

EXPOSE 4000

# 赋予脚本执行权限
RUN chmod +x ./docker-bootstrap.sh

# 在启动时将文件复制到 /app，避免直接挂载覆盖
CMD ["bash", "-c", "cp -r /opt/app/* /app && /app/docker-bootstrap.sh"]
