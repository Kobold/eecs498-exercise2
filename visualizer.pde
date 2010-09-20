import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.opengl.*;

int t = 0;
float circleBrightness = 40;
float circleDiameter;
float totalDiameter;

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
  background(0);
  
  if (beat.isKick()) {
    circleDiameter = totalDiameter * 0.8;
  }
  if (beat.isSnare()) {
    circleBrightness = 255;
  }
  
  fill(circleBrightness);
  noStroke();
  
  for (int i = 0; i < 360; i += 20) {
    circleToCenter(radians(i), circleDiameter, circleDiameter, 40, false);
  }
  
  t = (t + 1) % 36000;
  circleDiameter = constrain(circleDiameter * 1.01, totalDiameter * 0.8, totalDiameter);
  circleBrightness = constrain(circleBrightness * 0.9, 40, 255);
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

