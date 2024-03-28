package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("Header: %s\n", r.Header)
}

func main() {
	var port = "7777"
	http.HandleFunc("/", handler)

	fmt.Println("Started: " + port)

	http.ListenAndServe("127.0.0.1:"+port, nil)
}
