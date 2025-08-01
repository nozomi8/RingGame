class Ring {
  float x, y, z;
  float baseOuterRadius, baseInnerRadius;
  float outerRadius, innerRadius;
  float thickness;
  boolean isCounted = false;
  boolean isSuccess = false;
  boolean isFadingOut = false; 
  float fadeAlpha = 255; 
  
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

    color goldColor    = color(255, 215, 0);
    color warningColor = color(255, 255, 255);
    color successColor = color(0, 255, 0);
    if (isSuccess) {
      stroke(successColor, fadeAlpha);
    } else {
      if (z >= 0) {
        // z=0を過ぎて成功しなかったリングは、元の金色に戻る
        stroke(goldColor, fadeAlpha);
      } else {
        // z=0に近づいているリングは、金色から白色へ変化させる
        float amount = map(z, -1000, 0, 0, 1);
        amount = constrain(amount, 0, 1);
        color currentColor = lerpColor(goldColor, warningColor, amount);
        stroke(currentColor, fadeAlpha);
      }
    }
    ellipse(0, 0, outerRadius * 2, outerRadius * 2);
    popMatrix();
  }
  boolean isOffScreen() {
    return z > 100; // 画面より少し手前に来たら消す
  }
  boolean isPassedByPlayer(Player p) {
    float d = dist(this.x, this.y, p.x, p.y);
    return d + p.radius*0.9 < this.innerRadius;
  }
}