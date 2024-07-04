FROM alpine:latest

# Define built-time variables
# Can be retrieved in action yaml
ARG VERSION=1.0.0

RUN echo "Hello, world!" > /message.txt && \
    mkdir /data

VOLUME /data
EXPOSE 8080

CMD ["cat", "/message.txt"]


