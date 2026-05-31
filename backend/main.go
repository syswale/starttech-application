package main

import (
"fmt"
"net/http"
"os"
)

func main() {
// The crucial health check endpoint for your AWS Load Balancer
http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
w.WriteHeader(http.StatusOK)
w.Write([]byte("OK"))
})

// The root endpoint for the application
http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
w.WriteHeader(http.StatusOK)
w.Write([]byte("StartTech Backend is running!"))
})

// Default to port 8080
port := os.Getenv("PORT")
if port == "" {
port = "8080"
}

fmt.Printf("Server listening on port %s\n", port)
if err := http.ListenAndServe(":"+port, nil); err != nil {
fmt.Printf("Server failed to start: %v\n", err)
}
}
