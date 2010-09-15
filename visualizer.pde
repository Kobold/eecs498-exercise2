void setup()
{
  size(500, 500);
  
  background(0);
  noStroke();
  smooth();
  
  noLoop();
}

void draw()
{
  translate(width/2, height/2);
  
  for (int i = 0; i < 360; i += 20) {
    circleToCenter(radians(i), width/2, width/2, 20);
  }
}

void circle(float theta, float distance, float radius)
{
  ellipseMode(CENTER);
  ellipse(distance * cos(theta),
          distance * sin(theta),
          radius * 2, radius * 2);
}

void circleToCenter(float theta, float distance, float maxDistance, float maxRadius)
{
  if (distance < 5) {
    return;
  }
  
  float radius = maxRadius * distance / maxDistance;
  circle(theta, distance, radius);
  circleToCenter(theta, distance - 2 * radius - 3, maxDistance, maxRadius);
}

