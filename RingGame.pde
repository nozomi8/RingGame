// ===== ゲームの状態を定義 =====
enum GameState {
  TITLE,
  PLAYER_SELECT,
  STAGE_SELECT,
  PLAYING,
  STAGE_CLEAR,
  GAME_OVER
}
GameState currentGameState;

// ===== グローバル変数 =====
Player player;
Stage  currentStage;
UI     ui;
PImage strawberryImg, appleImg, melonImg;

int    stageNumber  = 1;
int    successCount = 0;
int    missCount    = 0;
int    maxMiss      = 3;

// ===== 初期設定 =====
void settings() {
  size(800, 600, P3D);
}

void setup() {
  frameRate(60);
  
  strawberryImg = loadImage("strawberry.png");
  appleImg      = loadImage("apple.png");
  melonImg      = loadImage("melon.png");
  
  ui = new UI();
  currentGameState = GameState.TITLE; // 最初の状態をタイトル画面に
}

// ===== メインループ =====
void draw() {
  background(0);
  switch (currentGameState) {
    case TITLE:
      ui.displayTitleScreen();
      break;
      
    case PLAYER_SELECT:
      ui.displayPlayerSelectScreen();
      break;

    // このケースを追加
    case STAGE_SELECT:
      ui.displayStageSelectScreen();
      break;

    case PLAYING:
      handlePlayerInput();
      currentStage.update();
      player.update();
      checkCollisions();
      drawGameScene();
      checkEndStage();
      break;

    case STAGE_CLEAR:
      drawGameScene();
      ui.displayStageClear();
      break;
      
    case GAME_OVER:
      drawGameScene();
      ui.displayGameOver();
      break;
  }
}

void mousePressed() {
  switch (currentGameState) {
    case TITLE:
      if (mouseY > height/2 && mouseY < height/2 + 40) {
        currentGameState = GameState.PLAYER_SELECT;
      }
      else if (mouseY > height/2 + 50 && mouseY < height/2 + 90) {
        currentGameState = GameState.STAGE_SELECT;
      }
      break;
      
    case PLAYER_SELECT:
      // Strawberry
      if (mouseY > height/2 - 50 && mouseY < height/2) {
        startGame("Strawberry", 1); // Stage1から開始
      }
      // Apple
      else if (mouseY > height/2 && mouseY < height/2 + 40) {
        startGame("Apple", 1);
      }
      // Melon
      else if (mouseY > height/2 + 50 && mouseY < height/2 + 90) {
        startGame("Melon", 1);
      }
      break;
      
    // ★★★ Stage Select画面のクリック処理を追加 ★★★
    case STAGE_SELECT:
      // Stage 1
      if (mouseY > height/2 - 50 && mouseY < height/2) {
        currentGameState = GameState.PLAYER_SELECT; // キャラ選択に戻る
        stageNumber = 1; // 開始ステージを1にセット
      }
      // Stage 2
      else if (mouseY > height/2 && mouseY < height/2 + 40) {
        currentGameState = GameState.PLAYER_SELECT;
        stageNumber = 2; // 開始ステージを2にセット
      }
      break;
      
    case STAGE_CLEAR:
      // Next Stage
      if (mouseY > height/2 && mouseY < height/2 + 40) {
        if(stageNumber < 2) switchStage(stageNumber + 1);
        else currentGameState = GameState.TITLE;
      }
      // Return to Title
      else if (mouseY > height/2 + 50 && mouseY < height/2 + 90) {
        currentGameState = GameState.TITLE;
      }
      break;
      
    case GAME_OVER:
      // Retry
      if (mouseY > height/2 && mouseY < height/2 + 40) {
        switchStage(stageNumber);
      }
      // Return to Title
      else if (mouseY > height/2 + 50 && mouseY < height/2 + 90) {
        currentGameState = GameState.TITLE;
      }
      break;
  }
}

void startGame(String playerType, int startStage) {
  if (playerType.equals("Strawberry")) player = new Strawberry(strawberryImg);
  else if (playerType.equals("Apple"))  player = new Apple(appleImg);
  else if (playerType.equals("Melon"))  player = new Melon(melonImg);
  
  switchStage(startStage);
}

void switchStage(int num) {
  stageNumber = num;
  if (num == 1) currentStage = new Stage1();
  else          currentStage = new Stage2();
  successCount = 0;
  missCount    = 0;
  currentGameState = GameState.PLAYING;
}

void handlePlayerInput() {
  if (mousePressed) {
    float gridW = width/3.0, gridH = height/3.0;
    int col = int(mouseX/gridW), row = int(mouseY/gridH);
    int dirX = 0, dirY = 0;
    if (col == 0) dirX = -1; else if (col == 2) dirX = 1;
    if (row == 0) dirY = -1; else if (row == 2) dirY = 1;
    player.move(dirX, dirY);
  }
}

void checkCollisions() {
  for (Ring r : currentStage.activeRings) {
    if (!r.isCounted && r.z >= 0) {
      if (r.isPassedByPlayer(player)) successCount++;
      else                            missCount++;
      r.isCounted = true;
    }
  }
}

void drawGameScene() {
  camera(width/2, height/2, 800,
         width/2, height/2, 0,
         0, 1, 0);
  currentStage.display();
  player.display();
  ui.displayControlGuides();
  ui.displayHUD(stageNumber, successCount, missCount, maxMiss);
}

void checkEndStage() {
  if (successCount >= 10) {
    currentGameState = GameState.STAGE_CLEAR;
  }
  if (missCount >= maxMiss) {
    currentGameState = GameState.GAME_OVER;
  }
}