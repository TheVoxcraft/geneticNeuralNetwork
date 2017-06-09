int board_size = 40;
float[][] food_board;
int food_board_size_x;
int food_board_size_y;
ArrayList<Creature> creatures;

float whenToReproduce = 10*60;
int startPopulation = 800;
int lowPopulation = 10;
int popSpark = 1;

void setup(){
  frameRate(600);
  noStroke();
  size(1200, 900);
  background(0);
  randomSeed(4);
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
  
  for(int i=0; i<startPopulation; i++){
    creatures.add(new Creature(new PVector(random(0,width-4), random(0,height-4)), new Network(),1));
  }
}

void draw(){
  for(int i=0;i<food_board_size_x;i++){
    for(int j=0;j<food_board_size_y;j++){
      fill(food_board[i][j]*200,0,60);
      rect(i*board_size, j*board_size, board_size, board_size);
      food_board[i][j] += .0002;
      food_board[i][j] = constrain(food_board[i][j], 0, 1);
    }
  }
  for (int i=creatures.size();i>0;i--) {
    int j = i-1;
    creatures.get(j).update();
    if(creatures.get(j).health <= 0){creatures.remove(j); }
  }
  
  for(int s=0; s < popSpark; s++){
    if(creatures.size() <= lowPopulation){
      // FIND SUTIBLE PARENTS
      Creature p1 = creatures.get((int)random(0, creatures.size()-1));
      float highestScore = 0;
      
      for(int i=0; i < creatures.size(); i++){
        if((creatures.get(i).lifetime*creatures.get(i).health) > highestScore){
          p1 = creatures.get(i);
          highestScore = creatures.get(i).lifetime*creatures.get(i).health;
        }
      }
      
      creatures.add(  new Creature(new PVector(random(0,width-4), random(0,height-4)), p1.brain.Reproduce(),1));
    }
  }
  fill(255);
  text("fps:"+round(frameRate), 10, 25);
  text("pop:"+round(creatures.size()), 10, 50);
}