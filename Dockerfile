FROM golang:1.11.1 as builder
RUN mkdir -p /go/src/github.com/cloudposse/fargate
WORKDIR /go/src/github.com/cloudposse/fargate
COPY . .
RUN go get -u github.com/golang/dep/cmd/dep && dep ensure && CGO_ENABLED=0 go build -v -o "./dist/build/fargate" *.go


FROM alpine:3.8
RUN apk add --no-cache ca-certificates
COPY --from=builder /go/src/github.com/cloudposse/fargate/dist/build/fargate /usr/bin/fargate
ENV PATH $PATH:/usr/bin
ENTRYPOINT ["fargate"]
