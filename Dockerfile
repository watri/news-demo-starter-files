FROM "golang:latest"
RUN yum install -y git
WORKDIR /go/src
COPY . /go/src
RUN cd /go/src && go build -o main
EXPOSE 3000
ENTRYPOINT "./main"
