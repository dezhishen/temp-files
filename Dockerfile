FROM golang:alpine as builder
WORKDIR /build
RUN apk add --no-cache upx 
COPY . .
RUN go build -ldflags="-s -w" -o /temp-files && \
    upx --lzma /temp-files

FROM alpine
EXPOSE 8080/tcp
WORKDIR /data
VOLUME /data
COPY --from=builder /temp-files /temp-files
RUN chmod +x /temp-files
ENTRYPOINT [ "/temp-files" ]
