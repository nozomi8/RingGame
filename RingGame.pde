GameManager gameManager;
enum GameState {
  TITLE,
  PLAYER_SELECT,
  STAGE_SELECT,
  PLAYING,
  STAGE_CLEAR,
  GAME_OVER
}

void settings() {
  size(800, 600, P3D);
}

void setup() {
  frameRate(60);
  gameManager = new GameManager(); 
}

void draw() {
  background(0);
  gameManager.update();
  gameManager.display(); 
}

void mousePressed() {
  gameManager.handleMouseInput(mouseX, mouseY);
}