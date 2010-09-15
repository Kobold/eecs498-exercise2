float rotation = 0;

void setup()
{
  size(750, 750);
  
  noStroke();
  smooth();
}

void draw()
{
  background(0);
  translate(width/2, height/2);
  
  float diagonal = sqrt(2) * width / 2;
  circlesToCenter(diagonal, diagonal, 30, false);
  rotation = (rotation + 0.5) % 360;
}

void circle(float theta, float distance, float radius)
{
  ellipseMode(CENTER);
  ellipse(distance * cos(theta),
          distance * sin(theta),
          radius * 2, radius * 2);
}

void circleToCenter(float distance, float radius, boolean opposite)
{
  for (int i = 0; i < 360; i += 20) {
    float rot = opposite ? -rotation : rotation;
    circle(radians(i + rot), distance, radius);
  }
}

void circlesToCenter(float distance, float maxDistance, float maxRadius, boolean opposite)
{
  if (distance < 5) {
    return;
  }
  
  float radius = maxRadius * distance / maxDistance;
  circleToCenter(distance, radius, opposite);
  circlesToCenter(distance - 2 * radius - 3, maxDistance, maxRadius, !opposite);
}

