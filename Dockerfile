FROM cooderl/wewe-rss-sqlite:latest

RUN apk update && \
    apk add --no-cache wget bash

WORKDIR /app

COPY docker-bootstrap.sh /app

EXPOSE 4000

RUN chmod +x ./docker-bootstrap.sh

CMD ["./docker-bootstrap.sh"]
