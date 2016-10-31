# espws2812 - Driving WS2812 Ledstrip using ESP-07 with NodeMCU firmware

This project uses the well known **ESP8266** Wifi/MCU module loaded with nodeMCU firmware to drive a WS2812 ledstrip. 

I've implemented an _extremely_ basic HTTP server (server.lua), that serves the included html file (index.html) when connecting to the ESP's IP address with a browser. This html file contains a modified version of Brian Grinsteads [Colorwheel 1K](http://www.briangrinstead.com/blog/colorwheel-1k), a tiny javascript color wheel library. This webpage sends GET requests to the esp, which the server parses, and passes the color values along to the ledstrip driver.
The leds are driven using the WS2812 library that comes with nodeMCU.

All of this ensures that the whole project takes up just 16749 bytes of SPIFFS memory, as to be compatible with 512kB versions of the ESP8266 modules.

This is in no way a finished product, feel free to use this code as inspiration though!
