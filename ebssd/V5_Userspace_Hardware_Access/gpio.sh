#!/bin/sh

echo '200' > /sys/class/gpio/export
echo 'out' > /sys/class/gpio/gpio200/direction
echo '1' > /sys/class/gpio/gpio200/value
cat /sys/class/gpio/gpio200/value
echo '200' /sys/class/gpio/unexport

