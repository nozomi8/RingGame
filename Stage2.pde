class Stage2 extends Stage {
  float amplitudeX = 250, amplitudeY = 100;
  float frequencyX = 0.015, frequencyY = 0.025;
  float phase = 0;

  Stage2() {
    super();
  }

  @Override
  void setupRings() {
    for (int i = 0; i < 15; i++) {
      ringQueue.add(new Ring(0, 0, -2500, 130, 90));
    }
  }

  @Override
  void update() {
    phase++;
    for (Ring r : activeRings) {
      r.x = amplitudeX * sin(phase * frequencyX);
      r.y = amplitudeY * cos(phase * frequencyY);
    }
    super.update();
  }

  @Override
  void drawBackground() {
    background(100, 150, 200);
  }
}