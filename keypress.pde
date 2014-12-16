// save image and reset
void keyReleased() {
  if (key == 'a') {
    seed++;
    randomSeed(seed);
    setBaseCircles();
    background(hue, 40, 12);
    counter = 0;
  }
  
  if ( key == 's' || key == 'S' ) {
    saveFrame("lines-######.png");
    seed++;
    randomSeed(seed);
    setBaseCircles();
    background(hue, 40, 12);
    counter = 0;
  }
  
  //gain modifers
  if (key == 'j')
    gainModifier++;

  if (key == 'k' )
    gainModifier--;
  
  if (key == '0')
    gainModifier = 0;
}  
