package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"
	"time"
)

const bufferSize = 4096

type User struct {
	Email       string `json:"email"`
	Name        string `json:"name"`
	ScreenName  string `json:"screen_name"`
	Followers   int    `json:"followers"`
	CreatedAt   string `json:"created_at"`
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("usage: go run main.go <filename>")
		return
	}
	file, err := os.Open(os.Args[1])
	if err != nil {
		fmt.Println(err)
		return
	}
	defer file.Close()
	reader := bufio.NewReaderSize(file, bufferSize)
	var users []User
	emailRegexp := regexp.MustCompile(`Email: ([^ ]+)`)
	nameRegexp := regexp.MustCompile(`Name: ([^ ]+)`)
	screenNameRegexp := regexp.MustCompile(`ScreenName: ([^ ]+)`)
	followersRegexp := regexp.MustCompile(`Followers: ([^ ]+)`)
	createdAtRegexp := regexp.MustCompile(`Created At: (.*)`)
	for {
		line, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		email := emailRegexp.FindStringSubmatch(line)
		name := nameRegexp.FindStringSubmatch(line)
		screenName := screenNameRegexp.FindStringSubmatch(line)
		followers := followersRegexp.FindStringSubmatch(line)
		createdAt := createdAtRegexp.FindStringSubmatch(line)
		if len(email) < 2 {
			email = []string{"Email:", "None"}
		}
		if len(name) < 2 {
			name = []string{"Name:", "None"}
		}
		if len(screenName) < 2 {
			screenName = []string{"ScreenName:", "None"}
		}
		if len(followers) < 2 {
			followers = []string{"Followers:", "None"}
		}
		if len(createdAt) < 2 {
			createdAt = []string{"Created At:", "None"}
		}
		createdAtNoNewline := strings.TrimSuffix(createdAt[1], "\r")
		if err != nil {
			fmt.Println(err)
			return
		}
		parsedCreatedAt, err := time.Parse(time.RubyDate, createdAtNoNewline)
		if err != nil {
			fmt.Printf("skipping line with invalid created_at field: %s\n", line)
			continue
		}
		formattedCreatedAt := parsedCreatedAt.Format("2006-01-02 15:04:05")
		user := User{
			Email:      email[1],
			Name:       name[1],
			ScreenName: screenName[1],
			Followers:  parseInt(followers[1]),
			CreatedAt:  formattedCreatedAt,
		}
		users = append(users, user)
	}
	jsonData, err := json.Marshal(users)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(string(jsonData))
}
func parseInt(s string) int {
	var i int
	fmt.Sscanf(s, "%d", &i)
	return i
}
