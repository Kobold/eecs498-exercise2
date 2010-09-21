import ddf.minim.*;
import ddf.minim.analysis.*;

int t = 0;
float circleBrightness = 0;
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
  size(750, 750, P2D);
  totalDiameter = circleDiameter = sqrt(2) * width / 2;
  
  // audio setup
  minim = new Minim(this);
  song = minim.loadFile("FinallyMoving.mp3", 2048);
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
  colorMode(HSB, 360, 100, 100);
  
  if (beat.isKick()) {
    circleDiameter = totalDiameter * 0.8;
  }
  if (beat.isSnare()) {
    circleBrightness = 22;
    if (colorChangeCount == 0) {
      primaryColor = (primaryColor + 20.0) % 360;
      secondColor = (primaryColor + 180.0) % 360;
    }
    colorChangeCount = (colorChangeCount + 1) % COLOR_CHANGE_RATE;
  }
  
  // draw background recursive circles
  fill(primaryColor, 80, circleBrightness);
  noStroke();
  for (int i = 0; i < 360; i += 30) {
    circleToCenter(radians(i), circleDiameter, circleDiameter, 40, false);
  }
  
  symmetrizedDotPattern(song.left.toArray(), song.left.size());
  
  t = (t + 1) % 36000;
  circleDiameter = constrain(circleDiameter * 1.01, totalDiameter * 0.8, totalDiameter);
  circleBrightness = constrain(circleBrightness * 0.98, 0, 22);
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

void plotDot(float r, float theta)
{
  float x = r * cos(theta);
  float y = r * sin(theta);
  point(x, y);
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

void symmetrizedDotPattern(float[] samples, int length)
{
  // various tweakable parameters
  float top = width / 2;
  float angle = 60;
  int lag = 32;
  
  // find the high and low values
  float high = -1e10, low = 1e10;
  for (int i = 0; i < length; i++) {
    high = max(high, samples[i]);
    low = min(low, samples[i]);
  }
  
  // rescale the samples to [0, top]
  float[] buffer = new float[length];
  for (int i = 0; i < length; i++) {
    buffer[i] = (samples[i] - low) * top / (high - low);
  }
  
  for (int j = 0; j < length - lag; j++) {
    if (buffer[j+lag] - buffer[j] >= 0) {
      stroke(primaryColor, 100, 100);
    } else {
      stroke(secondColor, 100, 100);
    }
    
    for (float i = 1; i < 360; i += angle) {
      plotDot(buffer[j], i+buffer[j+lag]);
      plotDot(buffer[j], i-buffer[j+lag]);
    }
  }
}

