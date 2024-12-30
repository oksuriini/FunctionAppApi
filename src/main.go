package main

import (
	"encoding/json"
	"io"
	"log"
	"net/http"
	"os"
)

type Message struct {
	Message string `json:"message"`
}

func parseBody(body io.ReadCloser) (string, error) {
	var parsedBody Message
	err := json.NewDecoder(body).Decode(&parsedBody)
	if err != nil {
		return "", err
	}

	return parsedBody.Message, nil
}

func messageHandler(w http.ResponseWriter, r *http.Request) {
	response, err := parseBody(r.Body)
	if err != nil {
		log.Fatalln(err)
	}

	w.Write([]byte(response))
}

func main() {
	addr := ":8080"
	if val, ok := os.LookupEnv("FUNCTIONS_CUSTOM_PORT"); ok {
		addr = ":" + val
	}

	http.HandleFunc("/api/message", messageHandler)

	log.Printf("Listening on %s", addr)
	log.Fatal(http.ListenAndServe(addr, nil))
}
