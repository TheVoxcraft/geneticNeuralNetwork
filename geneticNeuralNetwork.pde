class Network{
  
  int in_size = 5; // get-vector:position, get:health, get:food, get:memory, bias
  int l1_size = 21; // + 1 bias
  int l2_size = 21; // + 1 bias
  int out_size = 5; // vector:direction, bool:move, bool:eat, out:memory
  
  float[] in = new float[in_size];
  float[] l1 = new float[l1_size];
  float[] l2 = new float[l2_size];
  float[] out = new float[out_size];
  
  float[][] in_l1 = new float[in_size][l1_size];
  float[][] l1_l2 = new float[l1_size][l2_size];
  float[][] l2_out = new float[l2_size][out_size];
  
  float muationRate = .05;
  
  void randomizeWeights(){
    for(int i=0; i < in_size; i++){
      for(int j=0; j < l1_size; j++){
        in_l1[i][j] = random(-1.0, 1.0);
      }
    }
    for(int i=0; i < l1_size; i++){
      for(int j=0; j < l2_size; j++){
        l1_l2[i][j] = random(-1.0, 1.0);
      }
    }
    for(int i=0; i < l2_size; i++){
      for(int j=0; j < out_size; j++){
        l2_out[i][j] = random(-1.0, 1.0);
      }
    }
  }
  
  void setBias(){
  in[in_size-1] = 1;
  l1[l1_size-1] = 1;
  l2[l2_size-1] = 1;
  }
  
  float[] run(float[] inputs){
    // Insert inputs
    for(int i=0; i < in_size; i++){
      in[i] = inputs[i];
    }
    
    // Feed forward
    for(int i=0; i < in_size; i++){
      for(int j=0; j < l1_size; j++){
        l1[j] = in[i]*in_l1[i][j];
      }
    }
    for(int i=0; i < l1_size; i++){
      for(int j=0; j < l2_size; j++){
        l2[j] = l1[i]*l1_l2[i][j];
      }
    }
    for(int i=0; i < l2_size; i++){
      for(int j=0; j < out_size; j++){
        out[j] = l2[i]*l2_out[i][j];
      }
    }
    
    return out;
  }
  
  Network Reproduce(Network partner){
    Network child = new Network();
    
    for(int i=0; i < in_size; i++){
      for(int j=0; j < l1_size; j++){
        float c = random(0.0, 1.0);
        if(c > .5){
          child.in_l1[i][j] = partner.in_l1[i][j];
        } else {
          child.in_l1[i][j] = in_l1[i][j]; // self
        }
      }
    }
    for(int i=0; i < l1_size; i++){
      for(int j=0; j < l2_size; j++){
        float c = random(0.0, 1.0);
        if(c > .5){
          child.l1_l2[i][j] = partner.l1_l2[i][j];
        } else {
          child.l1_l2[i][j] = l1_l2[i][j]; // self
        }
      }
    }
    for(int i=0; i < l2_size; i++){
      for(int j=0; j < out_size; j++){
        float c = random(0.0, 1.0);
        if(c > .5){
          child.l2_out[i][j] = partner.l2_out[i][j];
        } else {
          child.l2_out[i][j] = l2_out[i][j]; // self
        }
      }
    }
    
    return child;
  }
  
  float tanh(float x){
    return (float)Math.tanh(x);
  }
  
  Network(){
    randomizeWeights();
    setBias();
  }
}

class Creature{
  PVector pos = new PVector(0, 0);
  float health = 1;
  float speed = 3;
  Network brain = new Network();
  Creature(PVector _pos){
    pos = _pos;
  }
  void display(){
    fill(health*190+10, 0, 0);
    ellipse(pos.x,pos.y, 10*health+10, 10*health+10);
  }
  void update(){
    display();
    health -= .01; //health decay
  }
  void move(PVector _dir){
    PVector dir = _dir.copy();
    dir.normalize();
    dir.mult(speed);
    pos.add(dir);
  }
}

int board_size = 40;
float[][] food_board;
int food_board_size_x;
int food_board_size_y;
ArrayList<Creature> creatures;

void setup(){
  size(800, 600);
  background(0);
  randomSeed(0);
  fill(255);
  creatures = new ArrayList<Creature>();
  food_board_size_x = width/board_size;
  food_board_size_y = height/board_size;
  food_board = new float[food_board_size_x][food_board_size_y];
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
    creature.update();
  }
  
}