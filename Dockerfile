FROM golang:1.14.2-alpine3.11
WORKDIR /go/src
COPY . /go/src
RUN cd /go/src && go build -o main
EXPOSE 3000
CMD ["/go/src/main"]
