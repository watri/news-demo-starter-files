FROM "golang:latest"
WORKDIR /go/src
COPY . /go/src
RUN cd /go/src && go build -o main
EXPOSE 3000
ENTRYPOINT "./main"
