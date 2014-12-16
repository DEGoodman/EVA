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

    // use perlin noise to "naturally randomize" direction
    void updateDir() {
        float n = noise(dirX, dirY)*width;
        float m = noise(dirY, dirX)*height;
        dirX += xincrement;
        dirY += yincrement;

        this.xPos = n;
        this.yPos = m;
    }
}

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
