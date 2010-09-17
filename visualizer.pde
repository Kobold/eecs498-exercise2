import processing.opengl.*;

int t = 0;

void setup()
{
  size(750, 750, OPENGL);
  noStroke();
}

void draw()
{
  translate(width/2, height/2);
  background(0);
  
  float col = 107.5 * cos(t / 8.0) + 147.5;
  fill(constrain(col, 40, 255));
  
  float distance = sqrt(2) * width / 2;
  for (int i = 0; i < 360; i += 20) {
    circleToCenter(radians(i), distance, distance, 40, false);
  }
  
  t = (t + 1) % 36000;
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

