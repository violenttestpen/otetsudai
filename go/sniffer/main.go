package main

import (
	"flag"
	"fmt"
	"net"
	"os"
	"strings"
	"time"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcapgo"
)

func printPayload(payload []byte) {
	var buffer []byte
	for idx, data := range payload {
		if idx%16 == 0 && idx != 0 {
			fmt.Printf("    %s\n", buffer)
			buffer = []byte("")
		}
		fmt.Printf("%02x ", data)
		if 32 <= data && data <= 126 {
			buffer = append(buffer, data)
		} else {
			buffer = append(buffer, '.')
		}
	}
	if len(buffer) != 0 {
		for idx := len(buffer); idx < 16; idx++ {
			fmt.Printf("   ")
		}
		fmt.Printf("    %s\n", buffer)
	} else {
		fmt.Printf("\n")
	}
}

func packetResolver(packet gopacket.Packet) {
	arp := packet.Layer(layers.LayerTypeARP)
	eth := packet.Layer(layers.LayerTypeEthernet)
	ipv4 := packet.Layer(layers.LayerTypeIPv4)
	ipv6 := packet.Layer(layers.LayerTypeIPv6)
	icmpv6 := packet.Layer(layers.LayerTypeICMPv6)
	icmpv4 := packet.Layer(layers.LayerTypeICMPv4)
	tcp := packet.Layer(layers.LayerTypeTCP)
	udp := packet.Layer(layers.LayerTypeUDP)
	dns := packet.Layer(layers.LayerTypeDNS)
	date := packet.Metadata().Timestamp.Local()
	year := date.Year()
	month := date.Month()
	day := date.Day()
	hour := date.Hour()
	minute := date.Minute()
	second := date.Second()
	nanosecond := date.Nanosecond()
	fmt.Printf("%04d-%02d-%02d %02d:%02d:%02d.%06d ", year, month, day, hour, minute, second, nanosecond/1000)
	if arp != nil {
		arpPkt, _ := arp.(*layers.ARP)
		if arpPkt.Operation == 1 {
			fmt.Printf("%s -> broadcast type 0x0806 ARP REQUEST who-has %s tell %s, length %d\n", net.HardwareAddr(arpPkt.SourceHwAddress), net.IP(arpPkt.DstProtAddress), net.IP(arpPkt.SourceProtAddress), len(arp.LayerPayload()))
		} else if arpPkt.Operation == 2 {
			fmt.Printf("%s -> %s type 0x0806 ARP RESPONSE %s is at %s, length %d\n", net.HardwareAddr(arpPkt.SourceHwAddress), net.HardwareAddr(arpPkt.DstHwAddress), net.IP(arpPkt.SourceProtAddress), net.HardwareAddr(arpPkt.SourceHwAddress), len(arp.LayerPayload()))
		} else {
			fmt.Printf("bad ARP packet received, ignoring...\n")
		}
		return
	} else if eth == nil {
		fmt.Fprintf(os.Stderr, "Warning: unable to detect ethernet layer for packet, skipping\n")
		return
	}
	ethPkt, _ := eth.(*layers.Ethernet)
	fmt.Printf("%s -> %s type 0x%04x len %d\n", ethPkt.SrcMAC, ethPkt.DstMAC, ethPkt.Contents[len(ethPkt.Contents)-2:], len(ethPkt.LayerPayload()))
	if ipv6 != nil {
		ipPkt, _ := ipv6.(*layers.IPv6)
		if icmpv6 != nil {
			fmt.Printf("%s -> %s ICMPv6\n", ipPkt.SrcIP, ipPkt.DstIP)
			printPayload(icmpv6.LayerPayload())
		} else if tcp != nil {
			tcpPkt, _ := tcp.(*layers.TCP)
			fmt.Printf("%s.%d -> %s.%d TCP", ipPkt.SrcIP, tcpPkt.SrcPort, ipPkt.DstIP, tcpPkt.DstPort)
			if tcpPkt.ACK {
				fmt.Printf(" ACK")
			} else if tcpPkt.SYN {
				fmt.Printf(" SYN")
			}
			fmt.Printf("\n")
			printPayload(tcp.LayerPayload())
		} else if udp != nil {
			udpPkt, _ := udp.(*layers.UDP)
			fmt.Printf("%s.%d -> %s.%d UDP\n", ipPkt.SrcIP, udpPkt.SrcPort, ipPkt.DstIP, udpPkt.DstPort)
			printPayload(udp.LayerPayload())
		} else {
			fmt.Printf("%s -> %s OTHER\n", ipPkt.SrcIP, ipPkt.DstIP)
			printPayload(ipPkt.LayerPayload())
		}
	} else if ipv4 != nil {
		ipPkt, _ := ipv4.(*layers.IPv4)
		if icmpv4 != nil {
			fmt.Printf("%s -> %s ICMPv4\n", ipPkt.SrcIP, ipPkt.DstIP)
			printPayload(icmpv4.LayerPayload())
		} else if tcp != nil {
			tcpPkt, _ := tcp.(*layers.TCP)
			fmt.Printf("%s.%d -> %s.%d TCP", ipPkt.SrcIP, tcpPkt.SrcPort, ipPkt.DstIP, tcpPkt.DstPort)
			if tcpPkt.ACK {
				fmt.Printf(" ACK")
			} else if tcpPkt.SYN {
				fmt.Printf(" SYN")
			}
			fmt.Printf("\n")
			printPayload(tcp.LayerPayload())
		} else if udp != nil {
			udpPkt, _ := udp.(*layers.UDP)
			if dns != nil {
				fmt.Printf("%s.%d -> %s.%d UDP DNS\n", ipPkt.SrcIP, udpPkt.SrcPort, ipPkt.DstIP, udpPkt.DstPort)
			} else {
				fmt.Printf("%s.%d -> %s.%d UDP\n", ipPkt.SrcIP, udpPkt.SrcPort, ipPkt.DstIP, udpPkt.DstPort)
			}
			printPayload(udp.LayerPayload())
		} else {
			fmt.Printf("%s -> %s OTHER\n", ipPkt.SrcIP, ipPkt.DstIP)
			printPayload(ipPkt.LayerPayload())
		}
	} else {
		fmt.Fprintf(os.Stderr, "Warning: unable to detect IP layer for packet, skipping\n")
		return
	}

	return
}

func liveCapture(ifaceName, pattern string, duration int) {
	handle, err := pcapgo.NewEthernetHandle(ifaceName)
	if err != nil {
		panic(err)
	}
	packetSource := gopacket.NewPacketSource(handle, layers.LayerTypeEthernet)

	timer := time.NewTimer(time.Duration(duration * int(time.Second)))
	timerC := timer.C

	fmt.Println("Live Capture Started...")

	packetC := packetSource.Packets()

	isRunning := true
	for isRunning {
		select {
		case <-timerC:
			isRunning = false
		case packet := <-packetC:
			if len(pattern) != 0 {
				if !strings.Contains(string(packet.Data()), pattern) {
					continue
				}
			}
			packetResolver(packet)
		}
	}
}

func main() {
	var ifaceName string
	var pattern string
	var duration int

	flag.StringVar(&ifaceName, "i", "", "Interface Name")
	flag.StringVar(&pattern, "s", "", "Pattern matching")
	flag.IntVar(&duration, "t", 0, "Duration in seconds")
	flag.Parse()

	liveCapture(ifaceName, pattern, duration)
}
