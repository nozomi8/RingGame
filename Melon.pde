class Melon extends Player {
  PImage playerImage;
  Melon(PImage img) {
    super();
    this.radius = 28;
    this.playerImage = img;
  }
  
  @Override
  void display() {
    pushMatrix();
    translate(width/2 + x, height/2 + y, 0);
    fill(255);
    noStroke();
    if (playerImage != null) {
      textureMode(NORMAL);
      texture(playerImage);
      sphere(radius);
    } else {
      fill(255, 60, 60);
      sphere(radius);
    }
    popMatrix();
  }
}