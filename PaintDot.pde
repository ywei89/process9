class PaintDot {
  Particle particle;
  float radius;
  color cc;
  ArrayList<PVector> trail;
  int size;
  
  PaintDot(Particle p) {
    particle = p;
    radius = 2;
    cc = color(127);
    trail = new ArrayList<PVector>();
    trail.add(p.position);
    size = 1;
  }
  
  void paint() {
    float b = map(particle.age, 0, MAX_AGE, 255, 100); // brightness
    float a = map(particle.velocity.magSq(), 0, 1000, 80,2); // alpha
    float w = map(particle.age, 0, MAX_AGE, 1, 5) * radius; // weight
    strokeWeight(w);
    stroke(b, a);
    noFill();
    beginShape();
    for (int i = 0; i < trail.size(); i++) {
        PVector current = trail.get(i);
        vertex(current.x, current.y);
    }
    endShape();
    if (trail.size() == size) {
      trail.remove(0);
    }
    trail.add(particle.position);
  }
}