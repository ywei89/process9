float G = 0.0098;
float E = 0.07;
float f = 0.99;

int MAX_AGE = 10000;

ArrayList<PaintDot> electrons;
PaintDot attractor;

void setup() {
  attractor = makeAttractor();
  electrons = new ArrayList<PaintDot>();
  
  for (int i = 0; i < 100; i++) { 
    electrons.add(makeElectron(attractor.particle.position, attractor.radius + 100));
  }
  
  for (int i = 0; i < 200; i++) {
    electrons.add(makeElectron());
  }
  
  size(500, 500);
}

void draw() {
  background(200);
  
  ArrayList<PaintDot> dead = new ArrayList<PaintDot>();  
  
  attractor.particle.update(brownianAccel(attractor.particle));
  if (outOfBound(attractor.particle)) {
    attractor.particle.velocity = attractor.particle.velocity.mult(-1);
  }
  // attractor.paint(pg);
  if (attractor.particle.age > MAX_AGE) {
    attractor = makeAttractor();
  }
  
  for (int i = 0; i < electrons.size(); i++) {
    PaintDot p = electrons.get(i);
    if (p.particle.isAlive) {
      /*
      if (PVector.dist(p.particle.position, attractor.particle.position) <= attractor.radius) {
        p.particle.isAlive = false;
        attractor.particle.electrictiy += p.particle.electrictiy;
        attractor.radius += 0.1 / sqrt(attractor.radius);
        continue;
      }
      */
      PVector a1 = gravityAccel(attractor.particle, p.particle);
      // PVector a2 = magneticAccel(attractor.particle, p.particle);
      PVector a3 = brownianAccel(p.particle);
      // p.particle.update(PVector.add(a1, a2, a3));
      p.particle.update(PVector.add(a1, a3));
      p.paint();
      if (p.particle.age > MAX_AGE) {
        p.particle.isAlive = false;
      }
      if (outOfBound(p.particle)) {
        PVector s = PVector.random2D();
        p.particle.velocity.mult(-1).add(s);
      }
    } else {
      dead.add(p);
    }
  }
  
  electrons.removeAll(dead);
    
  if (electrons.isEmpty()) {
    stop();
  }
}

void mouseClicked() {
  for (int i = 0; i < 100; i++) {
      electrons.add(makeElectron());
  }
}

PaintDot makeAttractor() {
  Particle p = new Particle();
  p.position = new PVector(200 + random(100), 200 + random(100));
  p.mass = 110 + random(30);
  p.age = int(random(10000));
  p.electrictiy = p.mass / 100;

  PaintDot d = new PaintDot(p);
  d.radius = 20;
  d.cc = color(0);
  return d;
}

PaintDot makeElectron() {
  Particle p = new Particle();
  p.position = new PVector(random(width), random(height));
  p.velocity = new PVector(-5 + random(10), -5 + random(10));
  p.mass = 1;
  p.electrictiy = 0;
  
  PaintDot e = new PaintDot(p);
  e.radius = 1;
  e.size = int(random(1, 10));
  return e;
}

PaintDot makeElectron(PVector center, float range) {
  Particle p = new Particle();
  p.position = new PVector(center.x - range + random(range * 2), center.y - range + random(range * 2));
  p.velocity = new PVector(-1 + random(2), -1 + random(2));
  p.mass = random(10);
  p.electrictiy = -10 + random(20);
  
  PaintDot e = new PaintDot(p);
  e.radius = p.mass / 2;
  e.particle.age = int(random(MAX_AGE / 2));
  return e;
}

boolean outOfBound(Particle p) {
  return (p.position.x < 0 || p.position.x > width || p.position.y < 0 || p.position.y > height);
}

PVector gravityAccel(Particle p0, Particle p1) {
  PVector accel = PVector.sub(p0.position, p1.position);
  float dsq = accel.mag();
  constrain(dsq, 500, 2500);
  float mag = G * p0.mass / dsq;
  accel.setMag(mag);
  return accel;
}

PVector magneticAccel(Particle p0, Particle p1) {
  PVector accel;
  if (p0.electrictiy != 0 && p1.electrictiy != 0) {
    accel = PVector.sub(p1.position, p0.position);
    float mag = E * abs(p0.electrictiy) / accel.magSq();
    if ((int(p0.electrictiy) ^ int(p1.electrictiy)) < 0) {
      accel = PVector.mult(accel, -1);
    }
    accel.setMag(mag);
  } else {
    accel = new PVector();
  }
  return accel;
}

PVector brownianAccel(Particle p) {
  return new PVector(-.001 + random(.002), -.001 + random(.002));
}