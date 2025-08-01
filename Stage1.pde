import java.util.Collections;
class Stage1 extends Stage {
  Stage1() {
    super();
  }

  @Override
  void setupRings() {
    ArrayList<Ring> ringPool = new ArrayList<Ring>();
    ringPool.add(new Ring(0, 0, -2000, 100, 60));
    ringPool.add(new Ring(200, 50, -2000, 100, 60));
    ringPool.add(new Ring(-150, -100, -2000, 100, 60));
    ringPool.add(new Ring(0, 100, -2000, 100, 60));
    ringPool.add(new Ring(0, -100, -2000, 100, 60));
    ringPool.add(new Ring(150, -100, -2000, 100, 60));
    ringPool.add(new Ring(-200, 50, -2000, 100, 60));
    ringPool.add(new Ring(100, 100, -2000, 100, 60));
    ringPool.add(new Ring(-100, -50, -2000, 100, 60));
    ringPool.add(new Ring(100, 100, -2000, 80, 50));
    ringPool.add(new Ring(-100, 100, -2000, 80, 50));
    ringPool.add(new Ring(100, -100, -2000, 80, 50));
    ringPool.add(new Ring(-100, -100, -2000, 80, 50));
    ringPool.add(new Ring(0, 0, -2000, 120, 80));
    Collections.shuffle(ringPool);
    ringQueue.addAll(ringPool);
  }

  @Override
  void drawBackground() {
    background(135, 206, 250); // 空色
  }
}