class Particle {
  PVector position;     // 位置
  PVector velocity;     // 速度
  PVector acceleration; // 加速度（重力など）
  float lifespan;       // 寿命
  color pColor;         // パーティクルの色
  float size;           // パーティクルのサイズ

  // コンストラクタ：パーティクルが生成される場所を引数に取る
  Particle(PVector startPosition) {
    // クラッカーのように四方八方に飛び散るための初期設定
    this.position = startPosition.copy();
    this.velocity = PVector.random2D().mult(random(2, 6)); // ランダムな方向にランダムな速度で
    this.acceleration = new PVector(0, 0.1); // 少しだけ下向きの重力
    this.lifespan = 255; // 寿命の初期値
    this.size = random(3, 8); // サイズをランダムに
    
    // 色をランダムに決める
    int choice = int(random(3));
    if (choice == 0) pColor = color(255, 255, 0);   // 黄色
    else if (choice == 1) pColor = color(0, 255, 255); // 水色
    else pColor = color(255, 100, 200); // ピンク
  }

  // 毎フレームの更新処理
  void update() {
    velocity.add(acceleration); // 速度に重力を加える
    position.add(velocity);     // 位置を速度分だけ動かす
    lifespan -= 4;            // 寿命を少しずつ減らす
  }

  // 描画処理
  void display() {
    noStroke();
    // 寿命に応じてだんだん透明にする
    fill(pColor, lifespan);
    ellipse(position.x, position.y, size, size);
  }

  // 寿命が尽きたかどうかを判定
  boolean isDead() {
    return lifespan < 0;
  }
}