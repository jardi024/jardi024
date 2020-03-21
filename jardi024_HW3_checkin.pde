//Initalize our graph of 8 nodes/milestones
int numNodes = 8;

//lets us reverse array lists
import java.util.Collections;

//Reperersent our graph structure as 3 lists
ArrayList<Integer>[] neighbors = new ArrayList[numNodes];  //A list of neighbors can can be reached from a given node
Boolean[] visited = new Boolean[numNodes]; //A list which store if a given node has been visited
int[] parent = new int[numNodes]; //A list which stores the best previous node on the optimal path to reach this node
PVector[] nodes = new PVector[numNodes];
ArrayList<Integer> path = new ArrayList<Integer>();
  
//Set start and goal
int start = 0;
int goal = 7;

ArrayList<Integer> fringe = new ArrayList(); 


//agent position
float ax;
float ay;
boolean reachgoal;



void setup() {
  
  
  reachgoal = false;
  
  //initialize the start and goal positions
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
          if((x1 < 300 || x1 > 700) && (y1 < 300 || y1 > 700)){
            nodes[i] = new PVector(x1, y1);
            suc = true;
          }
        }
      }
  }
  
  //Set which nodes are connected to which neighbors
  for (int i = 0; i < numNodes - 1; i++) {
    for (int j = i + 1; j < numNodes; j++){
      PVector v = PVector.sub(nodes[j],nodes[i]);
      v.normalize();
      PVector obst = new PVector(500,500);
      PVector c1 = PVector.sub(nodes[i], obst);
      float a = 1;
      float b = 2 * v.dot(c1);
      float c = pow(c1.mag(), 2) - pow(200, 2);
      
      float desc = pow(b,2) - (4*a*c);
      
      if(desc < 0){
        neighbors[i].add(j);
      }
      
    }
  }
  
  println("List of Neighbors:");
  println(neighbors);
  
  visited[start] = true;
  fringe.add(start);
  println("Adding node", start, "(start) to the fringe.");
  println(" Current Fring: ", fringe);
  
  
  while (fringe.size() > 0){
  int currentNode = fringe.get(0);
  fringe.remove(0);
  if (currentNode == goal){
    println("Goal found!");
    break;
  } 
  for (int i = 0; i < neighbors[currentNode].size(); i++){
    int neighborNode = neighbors[currentNode].get(i);
    if (!visited[neighborNode]){
      visited[neighborNode] = true;
      parent[neighborNode] = currentNode;
      fringe.add(neighborNode);
      println("Added node", neighborNode, "to the fringe.");
      println(" Current Fringe: ", fringe);
      }
    } 
  }
  
  
  print("\nReverse path: ");
  int prevNode = parent[goal];
  path.add(goal);
  print(goal, " ");
  while (prevNode >= 0){
    print(prevNode," ");
    path.add(prevNode);
    prevNode = parent[prevNode];
    }
  
  Collections.reverse(path);
  print(path);
  
  
  ax = nodes[path.get(0)].x;
  ay = nodes[path.get(0)].y;
  
 
  
  
  print("\n"); 
  
  print(nodes[0].x, "start x \n");
  print(nodes[0].y, "start y \n");
  print("\n");
  
  
  
  
  
  size(1000, 1000);
}


void updateAgent(){
  if(ax == nodes[goal].x && ay == nodes[goal].y){
    reachgoal = true;
  }
  if(reachgoal == false){
    if(ax == nodes[path.get(0)].x && ay == nodes[path.get(0)].y){
       path.remove(0);
       return;
    }
    if(ax < nodes[path.get(0)].x){
      ax++;
    }
    else{
      ax--;
    }
    if(ay < nodes[path.get(0)].y){
      ay++;
    }
    else{
      ay--;
    }
  }
}


void draw() {
  
  updateAgent();
  
  //draw circle obstacle in the middle
  pushMatrix();
  translate(500,500);
  circle(0, 0, 400);
  popMatrix();
  
  //draw start and goal (big squares)
  square(nodes[0].x, nodes[0].y, 50);
  square(nodes[7].x, nodes[7].y, 50);
  
  //draw connections between neighbors
  for (int i = 0; i < numNodes -1; i++){
    for (int j = 0; j < neighbors[i].size(); j++){
      line(nodes[i].x, nodes[i].y, nodes[neighbors[i].get(j)].x, nodes[neighbors[i].get(j)].y);
    }
  }
  
  //draw our other milestones (little squares)
  for(int i = 1; i < 7; i++){
    square(nodes[i].x, nodes[i].y, 30);
    square(nodes[i].x, nodes[i].y, 30);
  }
  
  //draw agent
  circle(ax,ay,10);
  
  
  
}
