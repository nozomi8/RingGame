abstract class Stage {
  ArrayList<Ring> ringQueue = new ArrayList<Ring>();
  ArrayList<Ring> activeRings = new ArrayList<Ring>();
  float stageSpeed = 10.0;

  Stage() {
    setupRings();
    spawnNextRing();
  }

  abstract void setupRings();
  abstract void drawBackground();

  void update() {
    for (Ring r : activeRings) {
      r.move(stageSpeed);
    }
    activeRings.removeIf(r -> r.isOffScreen());
    if (activeRings.isEmpty() && !ringQueue.isEmpty()) {
      spawnNextRing();
    }
  }

  void display() {
    drawBackground();
    for (Ring r : activeRings) {
      r.display();
    }
  }

  void spawnNextRing() {
    if (!ringQueue.isEmpty()) {
      activeRings.add(ringQueue.remove(0));
    }
  }

  int getRemainingRings() {
    return ringQueue.size() + activeRings.size();
  }
}