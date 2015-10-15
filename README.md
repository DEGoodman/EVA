EVA
=======

Eva is an environmental audio visualizer. She starts by determining the users location, then gathering data about the current weather using Yahoo's weather service. Eva listens to audio and dynamically creates images that change over time as a direct consequence of the sounds she hears.

The environment variables are:
  * Luminosity: determined by hour of day
  * Hue: determined by temperature

This program is built in [Processing](processing.org), and must be run from Processing.

The visual below is an example of one frame of the output. While it is in black and white, the actual program displays in full color.

![Example Visual](http://imgur.com/K4PBkSx.png, "Desaturated")

#### Version 2.0
Changes
 - v1.0 required a physical array of sensors and an arduino to gather data. v2.0 gets data from the internet and can be run from any laptop with an internet connection.

 Future implementaions:
  - fix image capture; currently only copies desaturated images, total loss of color
