class Melon extends Player {
  PImage playerImage;

  // コンストラクタは画像だけを受け取る
  Melon(PImage img) {
    super();
    this.radius = 28; // Melonのサイズ
    this.playerImage = img;
  }
  
  @Override
  void display() {
    pushMatrix();
    translate(width/2 + x, height/2 + y, 0);
    fill(255); // 色の設定をリセット
    noStroke();
    
    if (playerImage != null) {
      textureMode(NORMAL);
      texture(playerImage);
      sphere(radius);
    } else {
      // 画像がない場合の予備の色
      fill(180, 220, 140);
      sphere(radius);
    }
    popMatrix();
  }
}