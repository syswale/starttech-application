# Build Stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Download dependencies first (better caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the code
COPY . .

# Build the executable
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Production Stage
FROM alpine:latest

WORKDIR /root/

# Copy the pre-built binary file from the previous stage
COPY --from=builder /app/main .

# Expose port
EXPOSE 8080

# Command to run the executable
CMD ["./main"]
