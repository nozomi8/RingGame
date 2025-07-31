class GameManager {
  //  ゲームの状態
  GameState currentGameState;
  // ゲームの構成要素 
  Player player;
  Stage  currentStage;
  UI     ui;
  PImage strawberryImg;
  PImage appleImg; 
  PImage melonImg;
  PImage heartImg;
  //　ゲームのデータ
  int stageNumber  = 1;
  int successCount = 0;
  int missCount    = 0;
  int maxMiss      = 3;
  float shakeIntensity = 0; // 揺れの強さ
  boolean keyUp = false;
  boolean keyDown = false;
  boolean keyLeft = false;
  boolean keyRight = false;
  ArrayList<Particle> particles; // パーティクルを管理するリスト
  long clearScreenStartTime = 0; 
  long gameOverStartTime = 0;

  //コンストラクタ（初期設定） 
  GameManager() {
    ui = new UI();
    strawberryImg = loadImage("strawberry.png");
    appleImg      = loadImage("apple.png");
    melonImg      = loadImage("melon.png");
    heartImg = loadImage("heart.png"); 
    particles = new ArrayList<Particle>();
    currentGameState = GameState.TITLE;
  }

  // メインの更新・描画メソッド
   void update() {
    // プレイ中のみゲームのロジックを更新
    if (currentGameState == GameState.PLAYING) {
      handlePlayerInput();
      if (currentStage != null) {
        currentStage.update();
      }
      if (player != null) {
        player.update();
      }
      checkCollisions();
      checkEndStage();
    }
    // パーティクルは複数の画面で表示される可能性があるため、ここで更新
    if (!particles.isEmpty()) {
      for (int i = particles.size() - 1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.update();
        if (p.isDead()) {
          particles.remove(i);
        }
      }
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
        // プレイ中は3D世界と操作ガイド、HUDを全て描画
        draw3DWorld();
        if(ui != null) {
          ui.displayControlGuides();
          ui.displayHUD(stageNumber, successCount, missCount, maxMiss, heartImg);
        }
        break;
        
      case STAGE_CLEAR:
        // クリア画面では3D世界とクリアUIのみ描画
        draw3DWorld();
        if(ui != null) ui.displayStageClear();
        break;
        
      case GAME_OVER:
        // ゲームオーバー画面では3D世界とゲームオーバーUIのみ描画
        draw3DWorld();
        if(ui != null) ui.displayGameOver();
        break;
    }
    if (!particles.isEmpty()) {
      pushMatrix();
      translate(width/2, height/2);
      for (Particle p : particles) {
        p.display();
      }
      popMatrix();
    }
  }

  void draw3DWorld() {
    float shakeX = 0, shakeY = 0;
    if (shakeIntensity > 0) {
      shakeX = random(-shakeIntensity, shakeIntensity);
      shakeY = random(-shakeIntensity, shakeIntensity);
      shakeIntensity *= 0.9;
    }
    
    camera(width/2 + shakeX, height/2 + shakeY, 800,
           width/2 + shakeX, height/2 + shakeY, 0,
           0, 1, 0);
           
    if(currentStage != null) currentStage.display();
    
    // プレイ中だけプレイヤーを描画
    if(player != null && currentGameState == GameState.PLAYING) {
      player.display();
    }
  }
  
  // マウス入力処理 
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

  //  ヘルパーメソッド群 
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
    if (keyUp)    player.move(0, -1);
    if (keyDown)  player.move(0, 1);
    if (keyLeft)  player.move(-1, 0);
    if (keyRight) player.move(1, 0);
  }

  void checkCollisions() {
    if (currentStage == null || player == null) return;
    for (Ring r : currentStage.activeRings) {
      if (!r.isCounted && r.z >= 0) {
        if (r.isPassedByPlayer(player)) {
          successCount++;
          r.isSuccess = true;
          for (int i = 0; i < 50; i++) {
            particles.add(new Particle(new PVector(player.x, player.y), "confetti"));
          }
        } else {
          missCount++;
          shakeIntensity = 15.0f;
        }
        r.isCounted = true;
      }
    }
  }

  void drawGameScene() {
    float shakeX = 0, shakeY = 0;
    if (shakeIntensity > 0) {
      shakeX = random(-shakeIntensity, shakeIntensity);
      shakeY = random(-shakeIntensity, shakeIntensity);
      shakeIntensity *= 0.9;
    }
    camera(width/2 + shakeX, height/2 + shakeY, 800,
           width/2 + shakeX, height/2 + shakeY, 0,
           0, 1, 0);
           
    if(player != null && currentGameState == GameState.PLAYING) {
      player.display();
    }
    
    if(ui != null) {
      if (currentGameState == GameState.PLAYING) {
        ui.displayControlGuides();
      }
      ui.displayHUD(stageNumber, successCount, missCount, maxMiss, heartImg);
    }
    
    pushMatrix();
    translate(width/2, height/2);
    for (Particle p : particles) {
      p.display();
    }
    popMatrix();
  }

  void checkEndStage() {
    if (currentStage != null && currentStage.getRemainingRings() == 0 && successCount > 0) {
      if (currentGameState != GameState.STAGE_CLEAR) {
        clearScreenStartTime = millis();
        for (int i = 0; i < 200; i++) {
          particles.add(new Particle(new PVector(random(-width/2, width/2), random(-height/2, height/2)), "confetti"));
        }
      }
      currentGameState = GameState.STAGE_CLEAR;
    }
    if (missCount >= maxMiss) {
      if (currentGameState != GameState.GAME_OVER) {
        gameOverStartTime = millis();
        if(player != null) {
          for (int i = 0; i < 50; i++) {
            // ゲームの座標系(中央が0,0)に合わせるため、画面座標から幅/2, 高さ/2を引く
            float x = width/4 - width/2;
            float y = height/4 - height/2;
            particles.add(new Particle(new PVector(x, y), "explosion"));
          }
          
          // 右下からの爆発 (50個)
          for (int i = 0; i < 50; i++) {
            float x = width*3/4 - width/2;
            float y = height*3/4 - height/2;
            particles.add(new Particle(new PVector(x, y), "explosion"));
          }
        }
      }
      currentGameState = GameState.GAME_OVER;
    }
  }
  // キーボード入力処理
  void handleKeyPressed() {
    if (keyCode == UP)    keyUp = true;
    if (keyCode == DOWN)  keyDown = true;
    if (keyCode == LEFT)  keyLeft = true;
    if (keyCode == RIGHT) keyRight = true;
  }

  void handleKeyReleased() {
    if (keyCode == UP)    keyUp = false;
    if (keyCode == DOWN)  keyDown = false;
    if (keyCode == LEFT)  keyLeft = false;
    if (keyCode == RIGHT) keyRight = false;
  }
}