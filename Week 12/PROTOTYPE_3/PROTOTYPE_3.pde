// Calming Breathing Flower (Navy Text at Bottom)
// Inhale 4s → Hold 7s (shimmer) → Exhale 8s (shrink)

float INHALE = 4000;  // 4 seconds
float HOLD   = 7000;  // 7 seconds
float EXHALE = 8000;  // 8 seconds
float CYCLE  = INHALE + HOLD + EXHALE;

// Size settings
float baseSize = 90;        // base flower size
float sizeAmplitude = 70;   // breathing expansion amount

// Shimmer during HOLD
float shimmerAmp = 0.02;    // ±2% gentle pulse
float shimmerHz  = 0.7;     // 0.7 Hz shimmer rate

void setup() {
  size(700, 700);
  smooth();
  noStroke();
}

void draw() {
  drawSoftBackground();

  translate(width / 2, height / 2);

  float t = millis() % CYCLE;
  float progress;
  String phase;

  // --- Breathing phases ---
  if (t < INHALE) {
    float p = t / INHALE;
    progress = easeInOutSine(p);
    phase = "Inhale";
  } else if (t < INHALE + HOLD) {
    float holdTime = (t - INHALE) / 1000.0;
    float shimmer = shimmerAmp * sin(TWO_PI * shimmerHz * holdTime);
    progress = 1.0 + shimmer;
    phase = "Hold";
  } else {
    float p = (t - INHALE - HOLD) / EXHALE;
    progress = 1.0 - easeInOutSine(p);
    phase = "Exhale";
  }

  // 🌸 Calculate flower size
  float flowerSize = baseSize + sizeAmplitude * progress;

  // --- Draw petals ---
  int petals = 14;
  float angleStep = TWO_PI / petals;

  for (int i = 0; i < petals; i++) {
    pushMatrix();
    rotate(i * angleStep);
    fill(255, 235, 90, 190);  // soft, sunny yellow
    ellipse(0, -flowerSize, flowerSize * 0.55, flowerSize * 1.3);
    popMatrix();
  }

  // --- Center ---
  fill(255, 200, 70, 230);
  ellipse(0, 0, flowerSize * 0.65, flowerSize * 0.65);

  // --- Subtle glow ---
  float glowAlpha = 70;
  if (phase.equals("Hold")) {
    float holdTime = (t - INHALE) / 1000.0;
    glowAlpha += 20 * sin(TWO_PI * shimmerHz * holdTime);
  }
  fill(255, 255, 200, glowAlpha);
  ellipse(0, 0, flowerSize * 2.0, flowerSize * 2.0);

  // --- text (bottom of screen, navy blue) ---
  resetMatrix();
  fill(20, 40, 100); // navy blue
  textAlign(CENTER);
  textSize(40);
  text(phase, width / 2, height - 50);
}

// Soft gradient background
void drawSoftBackground() {
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(210, 240, 255), color(255), inter));
    line(0, y, width, y);
  }
}

// Smooth easing function
float easeInOutSine(float x) {
  return -0.5 * (cos(PI * x) - 1.0);
}
