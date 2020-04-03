//Initalize our graph of 8 nodes/milestones
int numNodes = 50;
int numAgents = 150;

//lets us reverse array lists
import java.util.Collections;

//Reperersent our graph structure as 3 lists
ArrayList<Integer>[] neighbors = new ArrayList[numNodes];  //A list of neighbors can can be reached from a given node
Boolean[] visited = new Boolean[numNodes]; //A list which store if a given node has been visited
int[] parent = new int[numNodes]; //A list which stores the best previous node on the optimal path to reach this node
PVector[] nodes = new PVector[numNodes]; //list of positions each milestone is at

// list of positions for each agent
PVector[] agents = new PVector[numAgents]; 

//direction our agent follows
PVector[] velocities = new PVector[numAgents]; 

//which node our agent is going to next
int[] nodenext = new int[numAgents];




void setup() {
  
  
 
  
  //initialize first and last positions
  nodes[0] = new PVector(100, 900);
  nodes[7] = new PVector(900, 100);
  
  // Initalize the lists which represent our graph 
  for (int i = 0; i < numNodes; i++) { 
      neighbors[i] = new ArrayList<Integer>();
      visited[i] = false;
      parent[i] = -1; //No parent yet
      
      //initialize random positions for the rest of the points
      if( i != 0 && i != 7){
        Boolean suc = false;
        while(suc == false){
          float x = random(100, 900);
          int x1 = (int) x;
          float y = random(100, 900);
          int y1 = (int) y;
          if((x1 < 300 || x1 > 700) && (y1 < 300 || y1 > 700) && (x1 < 175 || x1 > 225) && (y1 < 275 || y1 > 325) && (x1 < 675 || x1 > 725) && (y1 < 775 || y1 > 825)){
            nodes[i] = new PVector(x1, y1);
            suc = true;
          }
        }
      }
  }
  
  //Set which nodes are connected to which neighbors
  for (int i = 0; i < numNodes; i++) {
    for (int j = 0; j < numNodes; j++){
      PVector v = PVector.sub(nodes[j],nodes[i]);
      v.normalize();
      PVector obst = new PVector(500,500);
      PVector c1 = PVector.sub(nodes[i], obst);
      float a = 1;
      float b = 2 * v.dot(c1);
      float c = pow(c1.mag(), 2) - pow(200, 2);
      float desc1 = pow(b,2) - (4*a*c);
      
      
      v = PVector.sub(nodes[j],nodes[i]);
      v.normalize();
      obst = new PVector(200,300);
      c1 = PVector.sub(nodes[i], obst);
      a = 1;
      b = 2 * v.dot(c1);
      c = pow(c1.mag(), 2) - pow(25, 2);
      float desc2 = pow(b,2) - (4*a*c);
      
      v = PVector.sub(nodes[j],nodes[i]);
      v.normalize();
      obst = new PVector(700,800);
      c1 = PVector.sub(nodes[i], obst);
      a = 1;
      b = 2 * v.dot(c1);
      c = pow(c1.mag(), 2) - pow(25, 2);
      float desc3 = pow(b,2) - (4*a*c);
      
      if(desc1 < 0 && desc2 < 0 && desc3 < 0){
        neighbors[i].add(j);
      }
      
    }
  }
  
  
  
  
  for(int i = 0; i < numAgents; i++) {
    
    //initialize agent starting position
    float randnode = random(0,7);
    int randnode1 = (int)randnode;
    agents[i] = new PVector(nodes[randnode1].x,nodes[randnode1].y);
    
    //initialize agent desired position
    randnode = random(0, neighbors[randnode1].size());
    int randnode2 = (int)randnode;
    nodenext[i] = neighbors[randnode1].get(randnode2);
    
    //initialize agent velocity
    float xdir = nodes[nodenext[i]].x - agents[i].x;
    float ydir = nodes[nodenext[i]].y - agents[i].y;
    velocities[i] = new PVector(xdir,ydir);
    velocities[i].normalize();
    
  }
  
  
  
  
  size(1000, 1000);
}


void updateAgent(){
  
  
  for(int i = 0; i < numAgents; i++){
    
    //calculate neighbors for each agent
    ArrayList<Integer> agentneighbors = new ArrayList<Integer>();
    for(int j = 0; j < numAgents; j++){
      if(j != i){
        if(PVector.dist(agents[i], agents[j]) < 15){
          agentneighbors.add(j);
        }
      }
    }
    
    //calculate forces from neighbors
    for(int j = 0; j < agentneighbors.size(); j++) {
      float sepx = agents[i].x - agents[agentneighbors.get(j)].x;
      float sepy = agents[i].y - agents[agentneighbors.get(j)].y;
      PVector sepvel = new PVector(sepx,sepy);
      sepvel.normalize();
      sepvel.mult(2);
      velocities[i].add(sepvel);
    }
    
    //calculate goal force
    float goalx = nodes[nodenext[i]].x - agents[i].x;
    float goaly = nodes[nodenext[i]].y - agents[i].y;
    PVector goalvel = new PVector(goalx, goaly);
    goalvel.normalize();
    velocities[i].add(goalvel);
    velocities[i].limit(2);
    
    
    
    
    
    
   
    
    //calculate dist from milestone
    float xdist = abs(agents[i].x - nodes[nodenext[i]].x);
    float ydist = abs(agents[i].y - nodes[nodenext[i]].y);
    
    //if we are at milestone
    if(xdist < 10 && ydist < 1){
       //next node
       float randnode = random(0, neighbors[nodenext[i]].size());
       int randnode1 = (int)randnode;
       nodenext[i] = neighbors[nodenext[i]].get(randnode1);
       //next velocity
       float xdir = nodes[nodenext[i]].x - agents[i].x;
       float ydir = nodes[nodenext[i]].y - agents[i].y;
       velocities[i] = new PVector(xdir,ydir);
       velocities[i].normalize();
       
       return;
    }
    
    //add velocity to position
    agents[i].x = agents[i].x + velocities[i].x;
    agents[i].y = agents[i].y + velocities[i].y;
    
    
    
    //if in collision with obstacles
    if((agents[i].x > 290 && agents[i].x < 710) && (agents[i].y > 290 && agents[i].y < 710)){
      float sepx = agents[i].x - 500;
      float sepy = agents[i].y - 500;
      PVector sepvel = new PVector(sepx,sepy);
      sepvel.limit(2);
      agents[i].x = agents[i].x + sepvel.x;
      agents[i].y = agents[i].y + sepvel.y;
    }
    
    if((agents[i].x > 175 && agents[i].x < 225) && (agents[i].y > 275 && agents[i].y < 325)){
      float sepx = agents[i].x - 200;
      float sepy = agents[i].y - 300;
      PVector sepvel = new PVector(sepx,sepy);
      sepvel.limit(2);
      agents[i].x = agents[i].x + sepvel.x;
      agents[i].y = agents[i].y + sepvel.y;
    }
    
    if((agents[i].x > 675 && agents[i].x < 725) && (agents[i].y > 775 && agents[i].y < 825)){
      float sepx = agents[i].x - 700;
      float sepy = agents[i].y - 800;
      PVector sepvel = new PVector(sepx,sepy);
      sepvel.limit(2);
      agents[i].x = agents[i].x + sepvel.x;
      agents[i].y = agents[i].y + sepvel.y;
    }
  }
  
  
 
}


void draw() {
  background(209);
  updateAgent();
  
  // draw obstacles
  pushMatrix();
  translate(500,500);
  circle(0, 0, 400);
  popMatrix();
 
  pushMatrix();
  translate(200,300);
  circle(0, 0, 50);
  popMatrix();
  
  pushMatrix();
  translate(700,800);
  circle(0, 0, 50);
  popMatrix();
  
  
  
  /*//draw connections between neighbors
  for (int i = 0; i < numNodes -1; i++){
    for (int j = 0; j < neighbors[i].size(); j++){
      fill(0);
      line(nodes[i].x, nodes[i].y, nodes[neighbors[i].get(j)].x, nodes[neighbors[i].get(j)].y);
    }
  }*/
  
  //draw our other milestones (black circles)
  for(int i = 0; i < numNodes; i++){
    fill(0);
    circle(nodes[i].x, nodes[i].y, 10);
    circle(nodes[i].x, nodes[i].y, 10);
  }
  
  //draw agent
  fill(255);
  for(int i = 0; i < numAgents; i++){
    ellipse(agents[i].x,agents[i].y,15,15);
  }
  
  
  
  
}
