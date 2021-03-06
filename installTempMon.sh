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
tee -a /tmp/dht22.py <<EOF
import Adafruit_DHT
from time import sleep
sensor = Adafruit_DHT.DHT22
# DHT22 sensor connected to GPIO12.
pin = 12
print("[press ctrl+c to end the script]")
try: # Main program loop
   while True:
     humidity, temperature = Adafruit_DHT.read_retry(sensor,
pin)
     sleep(2.5)
     if humidity is not None and temperature is not None:
        print("Temp={0:0.1f}*C  Humidity={1:0.1f}%"
                           .format(temperature, humidity))
     else:
        print("Failed to get reading. Try again!")
# Scavenging work after the end of the program
except KeyboardInterrupt: print("Script end!")
EOF
# make the DHT22 script executable
sudo chmod +x /tmp/dht22.py
echo "Test script created in /tmp/ folder"

# Create logging script
tee -a /home/pi/logTmp.py <<EOF
import Adafruit_DHT as adht
import time
import logging

logging.basicConfig(filename='temperature.log', filemode='a', format='%(created)f %(message)s', level=logging.INFO)

while True:     
    h,t = adht.read_retry(adht.DHT22, 4)    
    logging.info('Temp={0:0.1f} C and Humidity={1:0.1f} %'.format(t, h))
EOF
# create script to run /home/pi/logTemp.sh with nohup
tee -a /home/pi/rundht22.sh <<EOF
#! /bin/bash

#python3 /home/pi/dht22.py >> /home/pi/temperatures.csv
nohup python3 /home/pi/logTemp.py &
EOF

# run the file
sudo bash /home/pi/rundht22.sh

#Set the script to run at reboot:

line="@reboot /home/pi/rundht22.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -


### Setting up InfluxDb and telegraf
# InfluxDb Installation on Raspberry Pi
wget -qO- https://repos.influxdata.com/influxdb.key | sudo tee /etc/apt/sources.list.d/influxdb.list test $VERSION\_ID = "8" && echo "deb https://repos.influxdata.com/debian jessie stable" | sudo tee /etc/apt/sources.list.d/influxdb.list test $VERSION\_ID = "9" && echo "deb https://repos.influxdata.com/debian stretch stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

sudo apt-get update && sudo apt-get install influxdb
sudo service influxdb start

#verify influxdb is running with the following command.
sudo service influxdb status
# Telgraf log parser Installation on Raspberry Pi
# Parsing logs on Raspberry Pi using telegraf
### Installing Grafana and creating dashboards on the Raspberry Pi
