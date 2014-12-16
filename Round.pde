
class Round {
  float xPos;
  float yPos;
  float dirX;
  float dirY;
  float dia;
  int col;
  boolean isVisible;

  Round(float xPos, float yPos, float dirX, float dirY, float dia, int col, boolean isVisible) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.dirX = dirX;
    this.dirY = dirY;
    this.dia = dia;
    this.col = col;
    this.isVisible = isVisible;
  }

  void drawCircle(int gain) {
    noStroke();
    
    /***** HUE *****/
    if (counter%5000 == 0)
      col += (1 - floor(random(4)))*30; //-30, 0, 30, 60
    col = hueHandler(col);
    this.col = int((col + 360) % 360);
    
    /***** SATURATION *****/
    int sat = int(map(lightRes, 0, 12, 30, 60));
    
    /***** BRIGHTNESS *****/
    int bright = 40 + lightRes*3;
    
    fill(col, sat, bright, 3);
    
    dia = pow((in.mix.level() + 1.02), gain/1.1);
    if (dia > 20) { //control for large values to avoid washing out entire screen
      fill(col, sat, bright - 10, 4);
    }
    if ( dia > 200) {
      dia = 200;
      fill(col, sat, bright - 20, 3);
    }
    // draw less circles to make sketch run slower
    println("hsb: " + col + ", " + sat + ", " + bright);
    ellipse(xPos, yPos, dia, dia);
  }

  void changeCol(int newCol) {
    this.col = newCol;
  }

  void setX(float x) {
    this.xPos = x;
  }  
  void setY(float y) {
    this.yPos = y;
  }  

  void updateDir() { // use perlin noise to "naturally randomize" direction
    float n = noise(dirX, dirY)*width;
    float m = noise(dirY, dirX)*height;
    dirX += xincrement;
    dirY += yincrement;

    this.xPos = n;
    this.yPos = m;
  }
}  

