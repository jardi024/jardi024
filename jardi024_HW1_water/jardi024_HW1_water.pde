
import peasy.*;
PeasyCam camera;

float[] xPosList = {0};
float[] yPosList = {0};
float[] zPosList = {0};
float[] xVelList = {50 * random(0.9, 1)};
float[] yVelList = {-9.8};
float[] zVelList = {20 * random(0.7, 1)};
float[] lifeList = {0};
float gravity = 9.8;


float genRate = 15;
float dt = 0.5;


void createParticles(float dt) {

  float numParticles = dt * genRate;
  numParticles = int(numParticles);
  for (int i = 0; i < numParticles; i++) {

    //position stuff
    float r = 20 * random(0, 1);
    float theta = 2 * PI * random(0, 1);
    float randxPosition = randomxPosition(r, theta);
    float randyPosition = randomyPosition(r, theta);
    xPosList = (float[])append(xPosList, randxPosition);
    yPosList = (float[])append(yPosList, randyPosition);
    zPosList = (float[])append(zPosList, 0);


    //velocity stuff

    xVelList = (float[])append(xVelList, 50 * random(0.9, 1));
    yVelList = (float[])append(yVelList, -9.8 * random(0, 1));
    zVelList = (float[])append(zVelList, 20 * random(0.7, 1));


    //life stuff
    lifeList = (float[])append(lifeList, dt);
  }
}

void moveParticles(float dt) {

  for (int i = 0; i < xPosList.length; i++) {
   
    if(lifeList[i] > 32){
        //do nothing
     }
    else{
    

      xPosList[i] = xPosList[i] + (xVelList[i] * dt);
      yPosList[i] = yPosList[i] + (yVelList[i] * dt);
      zPosList[i] = zPosList[i] + (zVelList[i] * dt);
  
  
      yVelList[i] = yVelList[i] + (gravity * dt);
      lifeList[i] = lifeList[i] + dt;
  
      if (yPosList[i] + 15 > 1000) {
        yPosList[i] = 1000;
        yVelList[i] = yVelList[i] * (-0.4 * random(0,1));

      }
    }
  }
}


float randomxPosition(float r, float theta) {

  float x = r * sin(theta);
  return x;
}

float randomyPosition(float r, float theta) {

  float y = r * cos(theta);
  return y;
}  


void setup() {
  fullScreen(P3D);
  
  // code is taken from processing forum and peasy library page
  float cameraFOV = 60 * DEG_TO_RAD;
  float cameraX = width / 2.0f;
  float cameraY = height / 2.0f;
  float cameraZ = cameraY / ((float) Math.tan(cameraFOV / 2.0f));
  camera = new PeasyCam(this, cameraX, cameraY, cameraZ, 50);
}




void draw() {
  background(0, 0, 0);
  createParticles(dt);
  moveParticles(dt);
  noStroke();
  translate(500, 500);
   
  //hose stuff
  pushMatrix();
  translate(-80, -80, -10);
  fill(192,192,192);
  sphere(100);
  translate(-100,-100,-10);
  box(100, 100, 400);
  popMatrix();
  

  
  fill(64, 164, 223);
  for (int i = 0; i < xPosList.length; i++) {
    pushMatrix();
    if(lifeList[i] > 32){
        //do nothing
     }
     else{
       translate(xPosList[i], yPosList[i], zPosList[i]);
       sphere(20);
     }
     
    popMatrix();
  }
  println(frameRate);
}
