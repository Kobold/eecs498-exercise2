import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.opengl.*;

int t = 0;
float circleShade = 100;
float circleDiameter;
float totalDiameter;

int COLOR_CHANGE_RATE = 20; // bigger numbers go slower
int colorChangeCount = 0;

float primaryColor = 0;
float secondColor = 180;

// audio related
Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

void setup()
{
  size(750, 750, OPENGL);
  totalDiameter = circleDiameter = sqrt(2) * width / 2;
  
  // audio setup
  minim = new Minim(this);
  song = minim.loadFile("ThisSpace.mp3", 2048);
  song.play();
  
  // beat detection
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(200);
  bl = new BeatListener(beat, song);
}

void draw()
{
  translate(width/2, height/2);
  
  colorMode(HSB, 360, 100, 100);
  background(secondColor, 100, 80);
  
  if (beat.isKick()) {
    circleDiameter = totalDiameter * 0.8;
  }
  if (beat.isSnare()) {
    circleShade = 1;
    if (colorChangeCount == 0) {
      primaryColor = (primaryColor + 20.0) % 360;
      secondColor = (primaryColor + 180.0) % 360;
    }
    colorChangeCount = (colorChangeCount + 1) % COLOR_CHANGE_RATE;
  }
  
  fill(primaryColor, circleShade, 80);
  noStroke();
  for (int i = 0; i < 360; i += 20) {
    circleToCenter(radians(i), circleDiameter, circleDiameter, 40, false);
  }
  
  t = (t + 1) % 36000;
  circleDiameter = constrain(circleDiameter * 1.01, totalDiameter * 0.8, totalDiameter);
  circleShade = constrain(circleShade * 1.2, 1, 100);
}

void stop()
{
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}

void circle(float theta, float distance, float radius)
{
  ellipseMode(CENTER);
  ellipse(distance * cos(theta),
          distance * sin(theta),
          radius * 2, radius * 2);
}

void circleToCenter(float theta, float distance, float maxDistance, float maxRadius, boolean opposite)
{
  if (distance < 5) {
    return;
  }
  
  float offset = opposite ? -radians(t / 4.0) : radians(t / 4);
  float radius = maxRadius * distance / maxDistance;
  circle(theta + offset, distance, radius);
  circleToCenter(theta, distance - 2 * radius - 3, maxDistance, maxRadius, !opposite);
}

