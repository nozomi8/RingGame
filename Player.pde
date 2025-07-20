class Player {
  float x = 0, y = 0; 
  float radius = 20;
  float speed = 5.0;    

  void update() {}

  void move(int dirX, int dirY) {
    x += dirX * speed;
    y += dirY * speed;
  }

  void display() {
    pushMatrix();
    translate(width/2 + x, height/2 + y, 0);
    fill(255);
    noStroke();
    fill(0, 255, 255);
    sphere(radius);
    popMatrix();
  }
}