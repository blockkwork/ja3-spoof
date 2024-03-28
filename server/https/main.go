package main

import (
	"crypto/tls"
	"fmt"
	"log"
	"net/http"

	"github.com/projectdiscovery/sslcert"
	"src.agwa.name/go-listener"
	"src.agwa.name/tlshacks"
)

func handler(w http.ResponseWriter, req *http.Request) {
	if req.URL.Path != "/" {
		http.NotFound(w, req)
		return
	}

	clientHello := req.Context().Value(tlshacks.ClientHelloKey).([]byte)
	info := tlshacks.UnmarshalClientHello(clientHello)
	fmt.Println(info.Info.JA3Fingerprint)
	fmt.Println(req.Cookies())
	w.Write([]byte(info.Info.JA3Fingerprint))
}

func main() {
	tlsOptions := sslcert.DefaultOptions
	hostname := "localhost"
	tlsOptions.Host = hostname

	tlsConf, err := sslcert.NewTLSConfig(tlsOptions)
	if err != nil {
		log.Panic(err.Error())
	}

	httpServer := &http.Server{
		Handler:     http.HandlerFunc(handler),
		ConnContext: tlshacks.ConnContext,
	}

	streamListener, err := listener.Open("tcp:7777")
	if err != nil {
		log.Fatal(err)
	}
	defer streamListener.Close()

	tlsListener := tls.NewListener(tlshacks.NewListener(streamListener), tlsConf)
	log.Fatal(httpServer.Serve(tlsListener))
}
