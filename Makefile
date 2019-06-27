BOARD_TAG         	= promicro16
ALTERNATE_CORE    	= sparkfun 
ALTERNATE_CORE_PATH	= ./hardware/SF32u4_boards/sparkfun/avr/
USER_LIB_PATH	  	= ./libraries


#ARDUINO_DIR	  	= /opt/arduino-1.8.5
ARDUINO_DIR	  	= /home/chuller/bin/arduino
ARDUINO_LIBS	  	= SharpIR


MONITOR_PORT	  	= /dev/ttyACM0 
#BOARDS_TXT        = /usr/share/arduino/hardware/arduino/boards.txt 
#BOOTLOADER_PARENT = $(HOME)/arduino/hardware/promicro/bootloaders
#BOOTLOADER_PATH   = caterina
#BOOTLOADER_FILE   = Caterina-promicro16.hex
#ISP_PROG     	   = usbasp
#AVRDUDE_OPTS 	   = -v
#include /usr/share/arduino/Arduino.mk
include Arduino-Makefile/Arduino.mk  

upload2:
	    /opt/arduino-1.8.5/hardware/tools/avr/bin/avrdude -C /opt/arduino-1.8.5/hardware/tools/avr/etc/avrdude.conf -p atmega32u4 -P /dev/ttyAMA0 -c avr109 -U flash:w:build-$(BOARD_TAG)/$(TARGET).hex
