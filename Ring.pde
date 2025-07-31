class Ring {
  float x, y, z;
  float baseOuterRadius, baseInnerRadius;
  float outerRadius, innerRadius;
  float thickness;
  boolean isCounted = false;
  boolean isSuccess = false;
  boolean isFadingOut = false; // 消えるアニメーション中か
  float fadeAlpha = 255;       // 透明度
  
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
    if (isFadingOut) {
      fadeAlpha -= 15; // だんだん透明にする
      float scaleUp = map(fadeAlpha, 255, 0, 1.0, 1.5); // だんだん大きくする
      outerRadius = baseOuterRadius * scaleUp;
    }
    if (fadeAlpha <= 0) return; // 完全に透明なら描画しない
    
    pushMatrix();
    translate(width / 2 + x, height / 2 + y, z);
    noFill();
    strokeWeight(thickness); 
    if (isSuccess) {
      stroke(0, 255, 0, fadeAlpha); // 成功色（透明度を適用）
    } else {
      stroke(255, 215, 0, fadeAlpha); // 通常色（透明度を適用）
    }
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