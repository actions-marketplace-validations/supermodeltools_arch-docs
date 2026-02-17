FROM golang:1.25-alpine AS builder
RUN apk add --no-cache git
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY main.go ./
COPY internal/ ./internal/
RUN CGO_ENABLED=0 go build -o /arch-docs main.go

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=builder /arch-docs /usr/local/bin/arch-docs
COPY templates/ /app/templates/
ENTRYPOINT ["/usr/local/bin/arch-docs"]
