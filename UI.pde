class UI {
  PFont scoreFont;
  PFont messageFont;

  UI() {
    scoreFont = createFont("Arial", 24);
    messageFont = createFont("Arial", 32);
  }

void displayHUD(int stageNum, int successCount, int missCount, int maxMiss, PImage heartIcon) {
  hint(DISABLE_DEPTH_TEST);
  camera();

  textFont(scoreFont);
  fill(255);
  textAlign(LEFT, TOP);
  text("Success: " + successCount, 10, 40);

  textSize(36);
  fill(255, 255, 0);
  textAlign(CENTER, TOP);
  text("Stage: " + stageNum, width / 2, 10);

  if (heartIcon != null) {
    int remainingLives = maxMiss - missCount; 
    for (int i = 0; i < remainingLives; i++) {
      image(heartIcon, 10 + (i * 35), 70, 32, 32);
    }
  }
  
  hint(ENABLE_DEPTH_TEST);
}
  // --- 各ゲーム画面の描画 ---

  void displayTitleScreen() {
    camera(); // 2D描画
    background(50, 80, 150);
    textFont(messageFont);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Aerial Ring Challenge", width / 2, height / 2 - 100);
    textSize(24);
    text("Start Game", width / 2, height / 2 + 20);
    text("Stage Select", width / 2, height / 2 + 70);
  }

  void displayPlayerSelectScreen() {
    camera();
    background(50, 80, 150);
    textFont(messageFont);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Select Player", width/2, height/2 - 100);
    textSize(24);
    text("Strawberry", width/2, height/2 - 30);
    text("Apple", width/2, height/2 + 20);
    text("Melon", width/2, height/2 + 70);
  }
  
  void displayGameOver() {
    camera(); 
    fill(0, 150);
    rect(0, 0, width, height);
    textFont(messageFont);
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width / 2, height / 2 - 50);
    fill(255);
    textSize(24);
    text("Retry", width/2, height/2 + 20);
    text("Return to Title", width/2, height/2 + 70);
  }

  void displayStageClear() {
    textFont(messageFont);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    text("STAGE CLEAR!", width / 2, height / 2 - 50);
    fill(255);
    textSize(24);
    text("Next Stage", width / 2, height / 2 + 20);
    text("Return to Title", width / 2, height / 2 + 70);
  }

  // --- 3D空間に描画するガイド ---
  void displayControlGuides() {
    strokeWeight(1);
    stroke(255, 50);
    noFill();
    float gridW = width / 3.0;
    float gridH = height / 3.0;
    line(gridW, 0, gridW, height);
    line(2 * gridW, 0, 2 * gridW, height);
    line(0, gridH, width, gridH);
    line(0, 2 * gridH, width, 2 * gridH);

    noStroke();
    fill(255, 100);
    float arrowSize = 15;
    drawArrow(gridW / 2, gridH / 2, -45.0, arrowSize);
    drawArrow(width / 2, gridH / 2, 0.0, arrowSize);
    drawArrow(width - (gridW / 2), gridH / 2, 45.0, arrowSize);
    drawArrow(gridW / 2, height / 2, -90.0, arrowSize);
    drawArrow(width - (gridW / 2), height / 2, 90.0, arrowSize);
    drawArrow(gridW / 2, height - (gridH / 2), -135.0, arrowSize);
    drawArrow(width / 2, height - (gridH / 2), 180.0, arrowSize);
    drawArrow(width - (gridW / 2), height - (gridH / 2), 135.0, arrowSize);
  }

  void drawArrow(float x, float y, float angle, float size) {
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    triangle(0, -size, -size * 0.7, size, size * 0.7, size);
    popMatrix();
  }

  void displayStageSelectScreen() {
    camera(); // Use 2D camera
    background(50, 80, 150); // Same background as other menus
    textFont(messageFont);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Select Stage", width / 2, height / 2 - 100);
    textSize(24);
    text("Stage 1", width / 2, height / 2 - 30);
    text("Stage 2", width / 2, height / 2 + 20);
  }
}