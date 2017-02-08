#!/bin/bash
# Create a Domoticz Hardware of type Dummy
# Create two Virtual Sensors of type Custom Sensor
# 1 sensor with name BitcoinValue and 1 sensor with name BitcoinWallet
# Enter amount of bitcoins in your wallet here:
number='0.09372178'
# SET the required currency: USD, GBP, EUR
currency="EUR"

# enter BitcoinValue Domoticz DeviceIdx:
bitcoinvalueidx=318

# enter BitcoinWallet Domoticz DeviceIdx:
bitcoinwalletidx=317

# add to crontab, without the comment #
# crontab -e
# */15 * * * * sleep $(expr $RANDOM \% 600); /home/pi/domoticz/scripts/bitcoin/bitcoin.sh 2>&1


bitcoin=$(curl -s http://api.coindesk.com/v1/bpi/currentprice.json | sed 's/","/\n/g' | grep -A2 $currency | grep 'rate"' | cut -d'"' -f3)
echo $bitcoin
wallet=$(awk "BEGIN {print $number*$bitcoin}")
echo $wallet
if [ "$bitcoin" != "" ] && [ "${bitcoin%.*}" -gt "100" ] ; then
	curl "http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=$bitcoinvalueidx&nvalue=0&svalue=$bitcoin;0"
	curl "http://127.0.0.1:8080/json.htm?type=command&param=udevice&idx=$bitcoinwalletidx&nvalue=0&svalue=$wallet;0"
fi
