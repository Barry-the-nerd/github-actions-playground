FROM ubuntu:latest

RUN echo "Hello, world!" > /message.txt

CMD ["cat", "/message.txt"]
