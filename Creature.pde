class Creature{
  PVector pos = new PVector(0, 0);
  float health = 1;
  float speed = 1;
  float mem = 0;
  int lifetime = 0;
  Network brain;
  Creature(PVector _pos, Network _brain, float _health){
    pos = _pos;
    brain = _brain;
    health = _health;
  }
  void display(){
    fill(150, health*190+10, 70);
    ellipse(pos.x,pos.y, 5*health+10, 5*health+10);
  }
  void update(){
    display();
    int currentFoodx = constrain((int)round(pos.x/board_size), 0, (width/board_size)-1);
    int currentFoody = constrain((int)round(pos.y/board_size), 0, (height/board_size)-1);
    float[] inputs = {currentFoodx,
                      currentFoody,
                      health,
                      food_board[currentFoodx][currentFoody],
                      mem};
                      
    float[] outputs = brain.run(inputs);
    health -= .0015; //health decay
    PVector d = new PVector(0, 0);
    if(outputs[2] > 0){
      d = new PVector(outputs[0], outputs[1]);
      health -= .0005;
    }
    
    if(outputs[3] > 0){
      if(food_board[currentFoodx][currentFoody] > 0){
        food_board[currentFoodx][currentFoody] -= .005;
        health += .002;
      }
    }
    if(outputs[5] > 0 && health >= -1){
      creatures.add(  new Creature(new PVector(random(pos.x-6,pos.x+12), pos.y-6,pos.y+12), brain.Reproduce(),.5));
      health -= .6;
    }
    mem = outputs[4];
    move(d);
    fill(255);
    lifetime++;
    //checkReproduce();
  }
  
  void checkReproduce(){
    for (int l=0;l<creatures.size();l++) {
      //print(getDistance(creatures.get(k).pos)+"\n");
      if((getDistance(creatures.get(l).pos) < 1) && (getDistance(creatures.get(l).pos) > 0)){
        creatures.add(  new Creature(new PVector(random(0,width-4), random(0,height-4)), brain.Reproduce(),1) );
        health *= .5;
        creatures.get(l).health *= .5;
        health -= .1;
        creatures.get(l).health -= .1;
      }
    }
  }
  
  float getDistance(PVector v2){ return pos.dist(v2);}
  
  void move(PVector _dir){
    PVector dir = _dir.copy();
    //dir.limit(1);
    dir.mult(speed);
    //PVector b = pos.copy();
    pos.add(dir);
    if(pos.x > width){pos.x = 0; }
    if(pos.y > height){pos.y = 0;}
    if(pos.x < 0){pos.x = width;}
    if(pos.y < 0){pos.y = height;}
  }
}