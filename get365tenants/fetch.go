package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"sync"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("provide a filename to work with!")
	}
	file, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	domains := strings.Split(string(file), "\n")
	f, err := os.Create(os.Args[1] + "365")
	if err != nil {
		log.Fatal(err)
	}
	var wg sync.WaitGroup
	for _, domain := range domains {
		wg.Add(1)
		go func(domain string) {
			defer wg.Done()
			resp, err := http.Get("https://login.microsoftonline.com/" + domain + "/.well-known/openid-configuration")
			if err != nil {
				log.Fatal(err)
			}
			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				log.Fatal(err)
			}
			if resp.StatusCode == 200 {
				tenantID := strings.Split(string(body), "sts.windows.net/")[1]
				tenantID = strings.Split(tenantID, "/")[0]
				fmt.Fprintln(f, domain + "," + tenantID)
			}
		}(domain)
	}
	wg.Wait()
}
