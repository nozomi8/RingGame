class Stage1 extends Stage {
  Stage1() {
    super();
  }

  @Override
  void setupRings() {
    ringQueue.add(new Ring(0, 0, -2000, 100, 60));
    ringQueue.add(new Ring(200, 50, -2000, 100, 60));
    ringQueue.add(new Ring(-150, -100, -2000, 100, 60));
    ringQueue.add(new Ring(0, 100, -2000, 100, 60));
    ringQueue.add(new Ring(0, -100, -2000, 100, 60));
    ringQueue.add(new Ring(150, -100, -2000, 100, 60));
    ringQueue.add(new Ring(-200, 50, -2000, 100, 60));
    ringQueue.add(new Ring(100, 100, -2000, 100, 60));
    ringQueue.add(new Ring(-100, -50, -2000, 100, 60));
    ringQueue.add(new Ring(0, 0, -2000, 100, 60));
  }

  @Override
  void drawBackground() {
    background(135, 206, 250); // 空色
  }
}