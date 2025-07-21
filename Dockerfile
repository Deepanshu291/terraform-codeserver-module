FROM ubuntu:24.04

RUN apt update && apt install -y curl git python3 python3-pip nodejs

RUN curl -fsSL https://code-server.dev/install.sh | sh

WORKDIR /root

EXPOSE 8080

COPY script.sh . 

RUN chmod +x script.sh

ENTRYPOINT [ "/root/script.sh" ]