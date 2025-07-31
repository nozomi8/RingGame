class Particle {
  PVector position;     // 位置
  PVector velocity;     // 速度
  PVector acceleration; // 加速度（重力など）
  float lifespan;       // 寿命
  color pColor;         // パーティクルの色
  float size;           // パーティクルのサイズ
  
  Particle(PVector startPosition, String type) {
    this.position = startPosition.copy();
    this.lifespan = 255;
    this.size = random(3, 8);
    
    if (type.equals("confetti")) {
      // ステージクリア用のカラフルなパーティクル
      this.velocity = PVector.random2D().mult(random(2, 6));
      this.acceleration = new PVector(0, 0.1); // ゆっくり落ちる
      int choice = int(random(3));
      if(choice == 0) pColor = color(255, 255, 0);
      else if (choice == 1) pColor = color(0, 255, 255);
      else pColor = color(255, 100, 200);
    } 
    else if (type.equals("explosion")) {
      //ゲームオーバー用の爆発パーティクル
      this.velocity = PVector.random2D().mult(random(1, 8));
      this.acceleration = new PVector(0, 0.15);
      // 3回に1回の確率で、閃光のような白いパーティクルを混ぜる
      if (random(1) < 0.33) {
        pColor = color(255); // 白
      } else {
        pColor = color(255, random(50, 150), 0); // 赤〜オレンジ
      }
    }
  }
   
  //毎フレームの更新処理
  void update() {
    velocity.add(acceleration); // 速度に重力を加える
    position.add(velocity);     // 位置を速度分だけ動かす
    lifespan -= 2;            // 寿命を少しずつ減らす
  }
    
  //描画処理
  void display() {
    noStroke();
    //寿命に応じてだんだん透明にする
    fill(pColor, lifespan);
    ellipse(position.x, position.y, size, size);
  }
    
  //寿命が尽きたかどうかを判定
  boolean isDead() {
    return lifespan < 0;
  }
}