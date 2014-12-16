// creates visual design. Reads and interprets data from online and local sources
// "Engaging Subset 4"

import com.onformative.yahooweather.*;
import ddf.minim.*;

YahooWeather weather;
int updateIntervallMillis = 60000; 

int vals; // will have to parse values
int temp; // temporary value location, to save memory
Minim minim;
AudioInput in;

int numCircles;
Round[] rounds;
float xincrement = 0.0007; 
float yincrement = 0.0007;

// sensors
int pot;
int lightRes;
int temperature;
int seed = 0;
int counter = 0;
int hue;
boolean seeLines = false;
boolean wait = false;
int lineCounter = 0;
int waitCounter = 300;
int gainModifier = 0;

void setup() {
  size(800, 600, P2D);
  
  // get weather data 
  // 2508428= the WOEID of Tucson
  // use this site to find out about your WOEID : http://sigizmund.info/woeidinfo/
  weather = new YahooWeather(this, 2508428, "f", updateIntervallMillis);
 
  //visuals
  minim = new Minim(this);
  in = minim.getLineIn();
  //in.enableMonitoring();

  colorMode(HSB, 360, 100, 100, 100 );
  //frameRate(10);

  rounds = new Round[0];  
  noStroke(); 
  smooth();
  setBaseCircles(); //create starter circles 
  if (getTemp() < 60) {
    hue = int(map(getTemp(), 20, 60, 320, 140));
  }  
  else {
    hue = int(map(getTemp(), 60, 120, 480, 360));
  }
  background(hue, 40, 12);
  // read data
  getData();
}

void draw() {
  println("temperature: " + temperature);
  println("lightres: " + lightRes);
  //check luminosity
  drawLegend();
  lightRes = setLuminosity();
  if(counter > 65000)
    counter = 5000;
  if(counter > 55000 && counter % 70 == 0) {
    // read data
    getData();
    weather.update();

    fill(hue, 40, 12, 4);
    rect(0, 0, width, height);
  }  
  
  lines(); 
  
  int gain = getGainLevel();
  println("gain: " + gain);

  //magic numbers to make it look nice
  xincrement = in.left.level()/10 + 0.0001;
  yincrement = in.right.level()/10 + 0.0001;

  for (int i = 0; i < numCircles; i++) { 
    //draw circles
    rounds[i].updateDir();
    //if(rounds[i].isVisible)
    rounds[i].drawCircle(gain); // use getGainValue info here
    drawLines(i);
  }
}


void setBaseCircles() { //static
  numCircles = 6;
  rounds = new Round[numCircles];
  boolean isVisible = false;
  // create base color
  int col;
  if (getTemp() < 60) {
    col = int(map(getTemp(), 20, 60, 320, 140));
  }  
  else {
    col = int(map(getTemp(), 60, 120, 480, 360));
  }
  for (int i = 0; i < numCircles; i++) {    
    //alternate visible circles
    isVisible = !isVisible;
    
    // create circles
    seed++;
    randomSeed(seed);
    rounds[i] = new Round(random(width), random(height), 1-floor(random(3)), 1-floor(random(13)), 200, col, isVisible);
  }
} 

void lines(){
  if(lineCounter <= 0 && seeLines) {
    lineCounter = 0;
    seeLines = false;
    wait = true;
  }  
  
  if(wait){
    waitCounter--;
  }

  if(waitCounter <= 0 && wait) {
    waitCounter = 300;
    wait = false;
  } 
}

void drawLines(int i){
  for (int j = 0; j < numCircles; j++) {
      counter++;
      if (  rounds[i].isVisible==true && rounds[j].isVisible==true && seeLines) {
        lineCounter--;
        int newCol = int((rounds[i].col + rounds[j].col)/2);
        stroke(newCol, 15, 88 + lightRes, 4);
        line(rounds[i].xPos, rounds[i].yPos, rounds[j].xPos, rounds[j].yPos );
      }
    }
}  

int hueHandler(int oldCol){
  // circles change color occasionally, within color temps
  int newCol = oldCol;
  if(getTemp() > 60){ //range: 320-500(140)
    if (newCol > 360)
      newCol -=360;
    else if (newCol < 320 && newCol > 140)
      newCol += 180;
  }   
  if(getTemp() <= 60) { //range: 140-320
    if(newCol > 320)
      newCol -= 180;
    else if (newCol < 140)
      newCol += 180;
  }    
  return newCol;
}  

void drawLegend(){
  textSize(12);
  fill(getTemp()*3, 30, 70, 20);
  text("reset- 'a'", 10, 30);
  text("save- 's'", 10, 50);
  text("gain up- 'j'", 10, 70);
  text("gain down- 'k'", 10, 90);
  text("gain 0- '0'", 10, 110);
}  
