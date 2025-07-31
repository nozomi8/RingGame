class Strawberry extends Player {
  PImage playerImage;

  // コンストラクタは画像だけを受け取る
  Strawberry(PImage img) {
    super(); // 親クラスの初期設定を呼び出す
    this.radius = 18;
    this.playerImage = img;
  }

    void display() {
    if (playerImage != null) {
      pushMatrix();
      // プレイヤーの現在位置に座標系を移動
      translate(width/2 + x, height/2 + y, 0);
      hint(DISABLE_DEPTH_MASK);
      // 画像の中心が座標の原点になるように設定
      imageMode(CENTER);

      // 画像を描画する
      image(playerImage, 0, 0, imageWidth, imageHeight);
      
      hint(ENABLE_DEPTH_MASK);
      popMatrix();
    } else {
      // 画像が読み込めなかった場合の代替表示（フォールバック）
      pushMatrix();
      translate(width/2 + x, height/2 + y, 0);
      println("Player image is null. Drawing fallback color.");
      fill(255, 60, 60);
      noStroke();
      sphere(radius);
      popMatrix();
    }
  }
}