// GameManager.pde の中身
class GameManager {
  // ===== ゲームの状態 =====
  GameState currentGameState;

  // ===== ゲームの構成要素 =====
  Player player;
  Stage  currentStage;
  UI     ui;
  PImage strawberryImg, appleImg, melonImg;
  
  // ===== ゲームのデータ =====
  int stageNumber  = 1;
  int successCount = 0;
  int missCount    = 0;
  int maxMiss      = 3;

  // ===== コンストラクタ（初期設定） =====
  GameManager() {
    ui = new UI();
    
    strawberryImg = loadImage("strawberry.png");
    appleImg      = loadImage("apple.png");
    melonImg      = loadImage("melon.png");
    
    currentGameState = GameState.TITLE;
  }

  // ===== メインの更新・描画メソッド =====
  void update() {
    if (currentGameState == GameState.PLAYING) {
      handlePlayerInput();
      if (currentStage != null) currentStage.update();
      if (player != null) player.update();
      checkCollisions();
      checkEndStage();
    }
  }

  void display() {
    switch (currentGameState) {
      case TITLE:
        ui.displayTitleScreen();
        break;
      case PLAYER_SELECT:
        ui.displayPlayerSelectScreen();
        break;
      case STAGE_SELECT:
        ui.displayStageSelectScreen();
        break;
      case PLAYING:
        drawGameScene();
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
  
  // ===== マウス入力処理 =====
  void handleMouseInput(int mx, int my) {
    switch (currentGameState) {
      case TITLE:
        if (my > height/2 && my < height/2 + 40) currentGameState = GameState.PLAYER_SELECT;
        else if (my > height/2 + 50 && my < height/2 + 90) currentGameState = GameState.STAGE_SELECT;
        break;
      case PLAYER_SELECT:
        if (my > height/2 - 50 && my < height/2) startGame("Strawberry", stageNumber);
        else if (my > height/2 && my < height/2 + 40) startGame("Apple", stageNumber);
        else if (my > height/2 + 50 && my < height/2 + 90) startGame("Melon", stageNumber);
        break;
      case STAGE_SELECT:
        if (my > height/2 - 50 && my < height/2) { stageNumber = 1; currentGameState = GameState.PLAYER_SELECT; }
        else if (my > height/2 && my < height/2 + 40) { stageNumber = 2; currentGameState = GameState.PLAYER_SELECT; }
        break;
      case STAGE_CLEAR:
        if (my > height/2 && my < height/2 + 40) {
          if (stageNumber < 2) switchStage(stageNumber + 1);
          else currentGameState = GameState.TITLE;
        } else if (my > height/2 + 50 && my < height/2 + 90) currentGameState = GameState.TITLE;
        break;
      case GAME_OVER:
        if (my > height/2 && my < height/2 + 40) switchStage(stageNumber);
        else if (my > height/2 + 50 && my < height/2 + 90) currentGameState = GameState.TITLE;
        break;
    }
  }

  // ===== ヘルパーメソッド群 =====
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
      float gridW=width/3.0, gridH=height/3.0;
      int col=int(mouseX/gridW), row=int(mouseY/gridH);
      int dirX=0, dirY=0;
      if(col==0)dirX=-1;else if(col==2)dirX=1;
      if(row==0)dirY=-1;else if(row==2)dirY=1;
      player.move(dirX, dirY);
    }
  }

  void checkCollisions() {
    if (currentStage == null) return;
    for (Ring r : currentStage.activeRings) {
      if (!r.isCounted && r.z >= 0) {
        if (r.isPassedByPlayer(player)) successCount++;
        else                            missCount++;
        r.isCounted = true;
      }
    }
  }

  void drawGameScene() {
    camera(width/2, height/2, 800, width/2, height/2, 0, 0, 1, 0);
    currentStage.display();
    if(player != null) player.display();
    if(ui != null) {
      ui.displayControlGuides();
      ui.displayHUD(stageNumber, successCount, missCount, maxMiss);
    }
  }

  void checkEndStage() {
    if (currentStage != null && currentStage.getRemainingRings() == 0 && successCount > 0) {
      currentGameState = GameState.STAGE_CLEAR;
    }
    if (missCount >= maxMiss) {
      currentGameState = GameState.GAME_OVER;
    }
  }
}