class Particle {
  float mass;
  PVector position;
  PVector velocity;
  float electrictiy;
  int age;
  boolean isAlive;
  
  Particle() {
    position = new PVector();
    velocity = new PVector();
    mass = 0;
    electrictiy = 0;
    age = 0;
    isAlive = true;
  } 
    
  void update(PVector acceleration) {
    velocity = PVector.add(velocity, acceleration).mult(1 - (1- f));
    position = PVector.add(position, this.velocity);
    age += 1;
  }
}