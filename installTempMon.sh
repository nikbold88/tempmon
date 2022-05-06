#! /bin/bash

# Update OS
sudo apt-get update
# Install build-essential and Python3
sudo apt-get install build-essential python3-dev
# Install Python3-pip
sudo apt-get install python3-pip
# Install the pip apps needed to install the DHT interface software
sudo python3 -m pip install --upgrade pip setuptools wheel
# Install the Adafruit_DHT library
sudo pip3 install Adafruit_DHT
# Create DHT22 script
# Test the DHT22 script
### Setting up InfluxDb and telegraf
# InfluxDb Installation on Raspberry Pi
# Telgraf log parser Installation on Raspberry Pi
# Parsing logs on Raspberry Pi using telegraf
### Installing Grafana and creating dashboards on the Raspberry Pi
