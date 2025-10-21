// Calming Breathing Flower – 4-7-8 Technique (No Rotation)
// Inhale 4s → Hold 7s → Exhale 8s (loops gently)

float INHALE = 4000;  // 4 seconds
float HOLD   = 7000;  // 7 seconds
float EXHALE = 8000;  // 8 seconds
float CYCLE  = INHALE + HOLD + EXHALE;

float baseSize = 70;       // flower base size
float sizeAmplitude = 25;  // how much it grows/shrinks

void setup() {
  size(600, 600);
  noStroke();
  smooth();
}

void draw() {
  // soft gradient background (light sky to white)
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(220, 245, 255), color(255), inter));
    line(0, y, width, y);
  }

  translate(width / 2, height / 2);

  float time = millis() % CYCLE;
  float scaleFactor;
  String phase;

  // Breathing cycle
  if (time < INHALE) {
    scaleFactor = map(time, 0, INHALE, 0, 1);
    phase = "Inhale";
  } else if (time < INHALE + HOLD) {
    scaleFactor = 1;
    phase = "Hold";
  } else {
    scaleFactor = map(time - INHALE - HOLD, 0, EXHALE, 1, 0);
    phase = "Exhale";
  }

  // Smooth easing for natural motion
  scaleFactor = easeInOutSine(scaleFactor);

  // Flower expands/contracts with breathing
  float flowerSize = baseSize + sizeAmplitude * scaleFactor;

  // Draw petals (no rotation)
  int petals = 12;
  float angleStep = TWO_PI / petals;
  for (int i = 0; i < petals; i++) {
    pushMatrix();
    rotate(i * angleStep);
    fill(255, 235, 100, 180);  // soft yellow petals
    ellipse(0, -flowerSize, flowerSize * 0.5, flowerSize * 1.2);
    popMatrix();
  }

  // Flower center
  fill(255, 200, 80, 220);
  ellipse(0, 0, flowerSize * 0.6, flowerSize * 0.6);

  // Gentle glow
  fill(255, 250, 200, 60);
  ellipse(0, 0, flowerSize * 1.8, flowerSize * 1.8);

  // Breathing guide text
  resetMatrix();
  fill(80, 100);
  textAlign(CENTER);
  textSize(16);
  text("4–7–8 Breathing • " + phase, width / 2, height - 40);
}

// Smooth easing for gentle breathing rhythm
float easeInOutSine(float x) {
  return -0.5 * (cos(PI * x) - 1);
}
