import peasy.*;
PeasyCam camera;

float[] xPosList = {0};
float[] yPosList = {0};
float[] zPosList = {0};
float[] xVelList = {50 * random(0.9, 1)};
float[] yVelList = {-9.8};
float[] zVelList = {20 * random(0.7, 1)};
float[] lifeList = {0};
float gravity = -9.8;


float genRate = 30;
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
    if(random(0,1) < 0.5) {
       xVelList = (float[])append(xVelList, 150 * random(0.3, 1));
    }
    else{
      xVelList = (float[])append(xVelList, -150 * random(0.3, 1));
    }
    yVelList = (float[])append(yVelList, -9.8 * random(0, 1));
    if(random(0,1) < 0.5) {
       zVelList = (float[])append(zVelList, 150 * random(0.3, 1));
    }
    else{
      zVelList = (float[])append(zVelList, -150 * random(0.3, 1));
    }


    //life stuff
    lifeList = (float[])append(lifeList, dt);
  }
}

void moveParticles(float dt) {

  for (int i = 0; i < xPosList.length; i++) {
   
    if(lifeList[i] > 30){
        //do nothing
     }
    else{
    

      xPosList[i] = xPosList[i] + (xVelList[i] * dt);
      yPosList[i] = yPosList[i] + (yVelList[i] * dt);
      zPosList[i] = zPosList[i] + (zVelList[i] * dt);
  
  
      yVelList[i] = yVelList[i] + (gravity * dt);
      if(xPosList[i] > 0){
        xVelList[i] = xVelList[i] - 9.8 * (2 * random(0,1)) ;
      }
      else{
        xVelList[i] = xVelList[i] + 9.8 * (2 * random(0,1));
      }
      lifeList[i] = lifeList[i] + dt;
  
      if(zPosList[i] > 0){
        zVelList[i] = zVelList[i] - 9.8 * (2 * random(0,1)) ;
      }
      else{
        zVelList[i] = zVelList[i] + 9.8 * (2 * random(0,1));
      }
      lifeList[i] = lifeList[i] + dt;
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
  translate(1500, 1500);
  
  pushMatrix();
  translate(0, 300, 0);
  fill(210,180,140);
  box(300, 600, 100);
  popMatrix();
   
  
  for (int i = 0; i < xPosList.length; i++) {
    pushMatrix();
    if(lifeList[i] > 30){
        //do nothing
     }
     else{
       float x = (lifeList[i]/30);
       fill(255, 255 - (255 * x), 0);
       translate(xPosList[i], yPosList[i], zPosList[i]);
       sphere(50);
     }
     
    popMatrix();
  }
  println(frameRate);
}
