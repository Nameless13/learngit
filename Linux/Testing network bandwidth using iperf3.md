title: Testing network bandwidth using iperf3
categories: [Linux]
date: 2018-05-23 09:57:35
---
# Testing network bandwidth using iperf3

## Background
Sometimes you want to test the network connection between two computers. Which tool will you use? Using web server and wget is an option, but it’s not very direct.

Using iperf3, you can easily measure the bandwidth from the client to the server as well as the bandwidth from the server to the client easily.

## How to install iperf3
Installing iperf3 on Debian/Ubuntu only needs one simple command.

`apt install iperf3`

On macOS, using homebrew is also very easy.

`brew install iperf3`

## How to use iperf3
On one of the computer (regarding as server), run iperf3 -s.

On the other computer (regarding as client), a common test is iperf3 -i 1 -t 30 -c SERVER_IP, which shows the result per second and lasts 30 seconds.
Note: This command shows the transfer speed from the client to the server. If you want the reverse, just add -R to the command.

