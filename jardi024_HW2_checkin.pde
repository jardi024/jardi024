//Triple Spring (damped) - 1D Motion
//CSCI 5611 Thread Sample Code
// Stephen J. Guy <sjguy@umn.edu>

//Create Window
void setup() {
  size(400, 500, P3D);
  surface.setTitle("Ball on Spring!");
}

//Simulation Parameters
float floor = 500;
float gravity = 40;
float radius = 10;
float stringTop = 50;
float restLen = 30;
float mass = 30; //TRY-IT: How does changing mass affect resting length?
float k = 100; //TRY-IT: How does changing k affect resting length?
float kv = 100;

//Inital positions and velocities of masses
float ballY1 = 200;
float ballX1 = 200;
float velY1 = 0;
float velX1 = 0;
float anchorX1 = 200;
float anchorY1 = stringTop;

float ballY2 = 250;
float ballX2 = 200;
float velY2 = 0;
float velX2 = 0;


float ballY3 = 300;
float ballX3 = 200;
float velY3 = 0;
float velX3 = 0;


void update(float dt) {
  //Compute (damped) Hooke's law for each spring
  float sx1 = (ballX1 - anchorX1);
  float sy1 = (ballY1 - anchorY1);
  float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
  float stringF1 = -k*(stringLen1 - restLen);
  float dirX1 = sx1/stringLen1;
  float dirY1 = sy1/stringLen1;
  float projVel1 = velX1*dirX1 + velY1*dirY1;
  float dampF1 = -kv*(projVel1 - 0);
  float springForceX1 = (stringF1+dampF1)*dirX1;
  float springForceY1 = (stringF1+dampF1)*dirY1;


  float sx2 = (ballX2 - ballX1);
  float sy2 = (ballY2 - ballY1);
  float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
  float stringF2 = -k*(stringLen2 - restLen);
  float dirX2 = sx2/stringLen2;
  float dirY2 = sy2/stringLen2;
  float projVel2 = velX2*dirX2 + velY2*dirY2;
  float dampF2 = -kv*(projVel2 - projVel1);
  float springForceX2 = (stringF2+dampF2)*dirX2;
  float springForceY2 = (stringF2+dampF2)*dirY2;

  float sx3 = (ballX3 - ballX2);
  float sy3 = (ballY3 - ballY2);
  float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
  float stringF3 = -k*(stringLen3 - restLen);
  float dirX3 = sx3/stringLen3;
  float dirY3 = sy3/stringLen3;
  float projVel3 = velX3*dirX3 + velY3*dirY3;
  float dampF3 = -kv*(projVel3 - projVel2);
  float springForceX3 = (stringF3+dampF3)*dirX3;
  float springForceY3 = (stringF3+dampF3)*dirY3;



  //float stringF3 = -k*((ballY3 - ballY2) - restLen);
  //float dampF3 = -kv*(velY3 - velY2);
  //float forceY3 = stringF3 + dampF3;

  //If are are doing this right, the top spring should be much longer than the bottom
  println("l1:", ballY1 - stringTop, " l2:", ballY2 - ballY1, " l3:", ballY3-ballY2);

  //Eulerian integration
  float accX1 = 0.5*springForceX1/mass - 0.5*springForceX2/mass;
  float accY1 = gravity + .5*springForceY1/mass - 0.5*springForceY2/mass; 

  velY1 += accY1*dt;
  ballY1 += velY1*dt;

  velX1 += accX1*dt;
  ballX1 += velX1*dt;

  float accX2 = 0.5*springForceX2/mass - 0.5*springForceX3/mass;
  float accY2 = gravity + .5*springForceY2/mass - 0.5*springForceY3/mass; 

  velY2 += accY2*dt;
  ballY2 += velY2*dt;

  velX2 +=   accX2*dt;
  ballX2 += velX2*dt;

  float accX3 = 0.5*springForceX3/mass;
  float accY3 = gravity + .5*springForceY3/mass; 

  velY3 += accY3*dt;
  ballY3 += velY3*dt;

  velX3 +=   accX3*dt;
  ballX3 += velX3*dt;

  //float accY2 = gravity + .5*forceY2/mass - .5*forceY3/mass; 
  //velY2 += accY2*dt;
  //ballY2 += velY2*dt;

  //float accY3 = gravity + .5*forceY3/mass; 
  //velY3 += accY3*dt;
  //ballY3 += velY3*dt;

  //Collision detection and response
  if (ballY1+radius > floor) {
    velY1 *= -.9;
    ballY1 = floor - radius;
  }
  if (ballY2+radius > floor) {
    velY2 *= -.9;
    ballY2 = floor - radius;
  }
  if (ballY3+radius > floor) {
    velY3 *= -.9;
    ballY3 = floor - radius;
  }
}


void keyPressed() {
  if (keyCode == RIGHT) {
    velX3 += 10;
  }
  if (keyCode == LEFT) {
    velX3 -= 10;
  }
}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255, 255, 255);
  update(.1); //We're using a fixed, large dt -- this is a bad idea!!
  fill(0, 0, 0);

  pushMatrix();
  line(anchorX1, anchorY1, ballX1, ballY1);
  translate(ballX1, ballY1);
  //sphere(radius);
  popMatrix();

  pushMatrix();
  line(ballX1, ballY1, ballX2, ballY2);
  translate(ballX2, ballY2);
  //sphere(radius);
  popMatrix();

  pushMatrix();
  line(ballX2, ballY2, ballX3, ballY3);
  translate(ballX3, ballY3);
  //sphere(radius);
  popMatrix();
}
