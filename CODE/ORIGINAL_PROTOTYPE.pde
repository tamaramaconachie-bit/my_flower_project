/**
 * 4-7-8 Breathing Flower (Processing / Java mode)
 * Inhale 4s (expand) → Hold 7s (steady) → Exhale 8s (contract) → repeat
 */

int NUM_PETALS = 12;
float minRadius = 80;    // smallest flower size
float maxRadius = 180;   // largest flower size
float petalWidth = 45;   // width of each petal

// Durations in milliseconds
final int INHALE = 0, HOLD = 1, EXHALE = 2;
int phase = INHALE;
int[] phaseDur = { 4000, 7000, 8000 };
int phaseStartMillis;

PFont f;

void setup() {
  size(700, 700);
  smooth(8);
  frameRate(60);
  phaseStartMillis = millis();
  f = createFont("Helvetica", 18, true);
}

void draw() {
  // Background
  background(15, 17, 28);
  translate(width/2, height/2);

  // Compute phase progress [0..1]
  int elapsed = millis() - phaseStartMillis;
  float p = constrain(elapsed / (float)phaseDur[phase], 0, 1);

  // Compute current radius based on phase
  float r;
  if (phase == INHALE) {
    r = lerp(minRadius, maxRadius, easeInOut(p));
  } else if (phase == HOLD) {
    r = maxRadius;
  } else { // EXHALE
    r = lerp(maxRadius, minRadius, easeInOut(p));
  }

  // Gentle color shift based on radius
  float t = map(r, minRadius, maxRadius, 0, 1);
  int bgGlow = color(40, 55, 115, 25);
  noStroke();
  // soft halo
  for (int i = 5; i >= 1; i--) {
    fill(red(bgGlow), green(bgGlow), blue(bgGlow), 10);
    ellipse(0, 0, r*2 + i*60, r*2 + i*60);
  }

  // Draw petals
  pushMatrix();
  float angleStep = TWO_PI / NUM_PETALS;
  for (int i = 0; i < NUM_PETALS; i++) {
    pushMatrix();
    rotate(i * angleStep);
    // Petal color changes a bit with breath
    int petalCol = lerpColor(color(180, 120, 255), color(255, 160, 200), t);
    drawPetal(r, petalWidth, petalCol);
    popMatrix();
  }
  popMatrix();

  // Flower center
  fill(255, 235, 140);
  noStroke();
  ellipse(0, 0, 40, 40);

  // HUD: phase label + progress ring
  drawHUD(p);
  
  // Handle phase switching
  if (elapsed >= phaseDur[phase]) {
    phase = (phase + 1) % 3;
    phaseStartMillis = millis();
  }
}

void drawPetal(float length, float width, int c) {
  // Petal shape: rounded teardrop using two arcs
  pushMatrix();
  translate(0, -length/2);
  // subtle breathing wobble for organic feel
  float wobble = 1.0 + 0.02 * sin(frameCount * 0.05 + random(1000));
  float w = width * wobble;
  float h = length;
  
  // Petal gradient (two layers)
  noStroke();
  for (int i = 0; i < 12; i++) {
    float k = map(i, 0, 11, 1.0, 0.4);
    int cc = lerpColor(c, color(255, 255, 255), 0.15*i/11.0);
    fill(red(cc), green(cc), blue(cc), 200);
    ellipse(0, h*0.52, w*k, h*k);
  }
  popMatrix();
}

void drawHUD(float phaseProgress) {
  pushMatrix();
  translate(0, height/2 - 80);
  // Progress ring
  noFill();
  strokeWeight(10);
  stroke(255, 255, 255, 40);
  ellipse(0, 0, 140, 140);
  stroke(140, 200, 255);
  float sweep = phaseProgress * TWO_PI;
  arc(0, 0, 140, 140, -HALF_PI, -HALF_PI + sweep);

  // Phase text
  String label = (phase == INHALE) ? "Inhale (4)" : (phase == HOLD) ? "Hold (7)" : "Exhale (8)";
  textFont(f);
  textAlign(CENTER, CENTER);
  fill(220);
  noStroke();
  text(label, 0, 0);
  popMatrix();
}

// Smooth easing for natural expansion/contraction
float easeInOut(float x) {
  // cubic ease in-out
  return (x < 0.5) ? 4*x*x*x : 1 - pow(-2*x + 2, 3)/2.0;
}
