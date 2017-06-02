class Network{
  
  int in_size = 8; // get:position, get:food, get:memory
  int l1_size = 20;
  int l2_size = 20;
  int out_size = 5; // vector:direction, bool:move, bool:eat, out:memory
  
}

class Creature{
  PVector pos = new PVector(0, 0);
  float health = 1;
  Network brain = new Network();
  Creature(PVector _pos){
    pos = _pos;
  }
  void updateGraphics(){
    fill(health*190+10, 0, 0);
    ellipse(pos.x,pos.y, 10*health+10, 10*health+10);
  }
  void move(){
    
    
  }
}

int board_size = 40;
float[][] food_board;
int food_board_size_x;
int food_board_size_y;
ArrayList<Creature> creatures = new ArrayList<Creature>();

void setup(){
  size(800, 600);
  background(0);
  fill(255);
  food_board_size_x = width/board_size;
  food_board_size_y = height/board_size;
  food_board = new float[food_board_size_x][food_board_size_y];
  print(food_board_size_x);
  for(int i=0;i<food_board_size_x;i++){
    for(int j=0;j<food_board_size_y;j++){
      food_board[i][j] = random(0.0, 1.0);
    }
  }
  
  creatures.add(new Creature(new PVector(50, 50)));
}

void draw(){
  for(int i=0;i<food_board_size_x;i++){
    for(int j=0;j<food_board_size_y;j++){
      fill(food_board[i][j]*200,0,60);
      rect(i*board_size, j*board_size, board_size, board_size);
    }
  }
  for (Creature creature : creatures) {
    creature.updateGraphics();
  }
  
}