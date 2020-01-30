float yposition = 200; 
float xposition = 300;
float yvelocity = 0;
float xvelocity = 20;
float radius = 40; 
float floor = 600;
float leftwall = 0;
float rightwall = 600;


void setup(){
size(600, 600, P3D);
}

void computePhysics(float dt){
  float acceleration= 9.8;
  yvelocity= yvelocity+ acceleration * dt;
  yposition = yposition + yvelocity * dt;
  xposition = xposition + xvelocity * dt;
  if(yposition + radius> floor){
    yposition = floor-radius;
    yvelocity *= -.95;
    xvelocity *= .95;
  }
  
  if(xposition + radius > rightwall){
    xposition = rightwall-radius;
    xvelocity *= -.95;
  }
  
  if(xposition - radius < leftwall){
    xposition = leftwall + radius;
    xvelocity *= -.95;
  }
  
  
}

void draw(){
  background(255,255,255);
  computePhysics(0.15);
  fill(0,200,10);
  noStroke();
  lights();
  translate(xposition,yposition);
  sphere(radius);
  
}
