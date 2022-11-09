package main
import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"golang.org/x/net/proxy"
)

func main() {
	var (
		socks5Proxy string
		userAgent   string
		method      string
	)
	flag.StringVar(&socks5Proxy, "socks5", "", "SOCKS5 proxy to use")
	flag.StringVar(&userAgent, "user-agent", "", "user agent to use")
	flag.Parse()
	if flag.NArg() != 1 {
		fmt.Println("usage: getsource <url>")
		os.Exit(1)
	}
	url := flag.Arg(0)
	if !strings.HasPrefix(url, "http") {
		url = "http://" + url
	}
	var client *http.Client
	if socks5Proxy != "" {
		dialer, err := proxy.SOCKS5("tcp", socks5Proxy, nil, proxy.Direct)
		if err != nil {
			log.Fatal(err)
		}
		client = &http.Client{
			Transport: &http.Transport{
				Dial: dialer.Dial,
			},
		}
	} else {
		client = &http.Client{}
	}
	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		log.Fatal(err)
	}
	if userAgent != "" {
		req.Header.Set("User-Agent", userAgent)
	}
	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(string(body))
}
