class Ring {
  float x, y, z;
  float baseOuterRadius, baseInnerRadius;
  float outerRadius, innerRadius;
  float thickness;
  boolean isCounted = false;

  Ring(float ringX, float ringY, float ringZ, float outerR, float innerR) {
    this.x = ringX;
    this.y = ringY;
    this.z = ringZ;
    this.baseOuterRadius = outerR;
    this.baseInnerRadius = innerR;
  }

  void move(float stageSpeed) {
    z += stageSpeed;
    updateSizeByZ();
  }

  void updateSizeByZ() {
    float scale = map(z, -2000, 0, 0.1, 1.0);
    outerRadius = baseOuterRadius * scale;
    innerRadius = baseInnerRadius * scale;
    thickness = (outerRadius - innerRadius) * 0.5;
  }

  void display() {
    pushMatrix();
    translate(width/2 + x, height/2 + y, z);
    noFill();
    strokeWeight(thickness);
    stroke(255, 215, 0);
    ellipse(0, 0, outerRadius * 2, outerRadius * 2);
    popMatrix();
  }

  boolean isOffScreen() {
    return z > 100; // 画面より少し手前に来たら消す
  }

  boolean isPassedByPlayer(Player p) {
    float d = dist(this.x, this.y, p.x, p.y);
    return d < this.innerRadius;
  }
}