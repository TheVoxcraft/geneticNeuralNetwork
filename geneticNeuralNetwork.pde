int board_size = 40;
float[][] food_board;
int food_board_size_x;
int food_board_size_y;
ArrayList<Creature> creatures;

float whenToReproduce = 10*60;
int startPopulation = 600;
int lowPopulation = 250;
int popSpark = 25;

void setup(){
  frameRate(600);
  size(1200, 1000);
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
  
  for(int i=0; i<startPopulation; i++){
    creatures.add(new Creature(new PVector(random(0,width-400), random(0,height-400)), new Network()));
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
    for (int l=creatures.size();l>0;l--) {
      if((creatures.get(j).getDistance(creatures.get(l-1).pos) < 2) && (creatures.get(j).health > .7) && (creatures.get(l-1).health > .7) && (j!=l-1)){
        creatures.add(  new Creature(new PVector(random(0,width-400), random(0,height-400)), creatures.get(j).brain.Reproduce(creatures.get(l-1).brain)) );
        creatures.get(j).health -= .2;
        creatures.get(l-1).health -= .2;
      }
    }
  }
  
  for(int s=0; s < popSpark; s++){
    if(creatures.size() <= lowPopulation){
      // FIND SUTIBLE PARENTS
      Creature p1 = creatures.get((int)random(0, creatures.size()-1));
      Creature p2 = creatures.get((int)random(0, creatures.size()-1));;
      float highestHP = 0;
      
      for(int i=0; i < creatures.size(); i++){
        if(creatures.get(i).health > highestHP){
          p2 = p1;
          p1 = creatures.get(i);
          highestHP = creatures.get(i).health;
        }
      }
      
      creatures.add(  new Creature(new PVector(random(0,width-400), random(0,height-400)), p1.brain.Reproduce(p2.brain)));
    }
  }
  fill(255);
  text("fps:"+round(frameRate), 10, 25);
  text("pop:"+round(creatures.size()), 10, 50);
}