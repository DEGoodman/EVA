int setLuminosity(){
  println("hour: " + hour());
  if (hour() < 12)
    return hour() + 1;
  else {
    int h = int(map(hour(), 12, 23, 12, 1));
    return h;
  }
}

void getData() {
  lightRes = getLight();
  temperature = getTemp();
} 

int getGainLevel() {
  /* I can normalize the 'gain' (here, the power) by making an array and reading in the levels, and take average.
   * can update the array (array[i] = array[i+1], array[last] = new level), then average results
   * scale accordingly to get reasonable 'power'
   sa*/

 float maxVolume = in.mix.level();
    
  // scale maxVolume for MAX GAINZ!!!!  0.02-0.14
  if (maxVolume <= 0.02) {
    seeLines = false;
    return 65 + gainModifier;
  }  
  else if (maxVolume <= 0.07){ 
    if (gainModifier < 1)
      seeLines();
    else
      seeLines = false;
    return 50 + gainModifier;
  }  
  else if (maxVolume <= 0.14) { 
    seeLines();
    return 35 + gainModifier; 
  }  
  else if (maxVolume <= 0.20){
    seeLines = false;
    for(int i = 0; i < numCircles; i++)
      rounds[i].isVisible = !rounds[i].isVisible;
    return 25 + gainModifier;
  }  
  else{
    seeLines = false;
    return 18 + gainModifier;
  }  
}

//turn on connecting lines
void seeLines(){
  if (!seeLines && !wait) {
    seeLines = true;
    lineCounter = 1000;
  }  
}    

// based on time of day
int getLight() {
  temp = setLuminosity();
  return temp;
}  

//from user location
int getTemp() {
  //find users' local temperature
  int t = int(weather.getTemperature());
  if(t > 120)
    t = 120;
  if(t < 20)
    t = 20;  
  return 55;
}  


