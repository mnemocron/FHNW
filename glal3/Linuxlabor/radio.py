#!/usr/bin/python
#_*_ coding: utf-8 _*_

'''
@file 	
@author 
@date 	
'''


import sys
import os
import urllib.request
from bs4 import BeautifulSoup

url = 'http://www.listenlive.eu/switzerland.html'
conn = urllib.request.urlopen(url)
html = conn.read()

bs = BeautifulSoup(html, 'lxml')

elements = bs.find_all('tr')

stations = [[]]

for el in elements:
	station_name = ''
	station_url = ''
	subs = el.find_all('td')
	for sub in subs:
		title = sub.find('b')
		if title is not None:
			station_name = title.text
		links = sub.find_all('a')
		for link in links:
			href = link.get('href', None)
			if 'm3u' in href:
				if 'high' in href or '128' in href:
					station_url = href
	if len(station_name) > 1 and len(station_url) > 1:
		stations.append([station_name, station_url])

stations.pop(0)

index = 1
for station in stations:
	print(str(index) + '\t' + str(station[0]))
	index += 1

while 1:
	u_index = int(input())
	print(str(u_index))
	if(u_index > len(stations)):
		print(str(u_index) + ' : [out of index]')
	else:
		print('playing: ' + str(u_index) + ' ' + stations[u_index][0])
		print(str(stations[u_index][1]))
		os.system('mplayer -noconsolecontrols -playlist ' + str(stations[u_index][1]))

