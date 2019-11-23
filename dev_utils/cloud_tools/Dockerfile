FROM node:lts-alpine
LABEL maintainer "ymmmtym"

ENV HOSTNAME="cloud_tools" \
    PS1="[\u@\h \W]# "

RUN apk update && \
    yarn global add firebase-tools heroku
