public class Player{
  private Screen world;
  
  // Extra character count.
  final int CHAR_COUNT = 3 - 1;
  
  
  // Animation delay. For jump animations it's even bigger.
  final int DELAY = 6;
  
  // Modify the size of a player throught these constants.
  final float W_SIZE = blockSize;
  final float H_SIZE = blockSize;
  
  // World properties.
  final float FRICTION = 0.70;
  final float GRAVITY = 1.2; 
  final float accX = 0.7;       // Acceleration value for X-axis.
  
  // Maximum jump and running speed values.
  // These are default for the first character.
  final int SPEED_MAX = 15;
  final int JUMP_MAX = 130;
  
  
  private float maxJump;
  private float maxVelocity;
  private boolean isInAir;
  private int collision;
  
  // Actual size of player's hitbox.
  private float w;
  private float h;
  
  // Player animation size, which is bigger than it's hitbox.
  private float imageWidth;
  private float imageHeight;
  

  // Player positions.
  private float x;
  private float y;
  
  // Speed values.
  private float velocityX;
  private float velocityY;
  

  
  // Display information.
  private PImage current_frame;
  private int char_id;
  private int frame_id;
  private int direction;
  
    
  private PImage[][][] idles;
  private PImage[][][] runs;
  private PImage[][][] jumps;
  
  Player(Screen world, float posX, float posY){
    // Tie Player object with the current world.
    this.world = world;
    
    loadSprites();

    // Setting up player's size.
    this.imageWidth =  W_SIZE * 1.1;
    this.imageHeight = H_SIZE * 1.1;
    
    // Hitbox size.
    this.w = W_SIZE * 0.6;
    this.h = H_SIZE * 0.9;
    
    // Starting position.
    this.x = posX;
    this.y = posY;
    
    
    // Setting up the first character and its frames.
    this.char_id = 0;
    this.direction = RIGHT;
    this.current_frame = this.idles[direction][0][0];
    this.frame_id = 0;
    this.isInAir = true;
    this.collision = NONE;
    
    // Starting values velocity & jump speed values.
    this.velocityX = 0.0;
    this.velocityY = 0.0;
    
    this.maxVelocity = SPEED_MAX;
    this.maxJump = JUMP_MAX;
  }
 
 // Forcing to use other constructor.
 private Player(){};
  
 private void loadSprites(){
    idles = new PImage[2][3][4];
    runs = new PImage[2][3][6];
    jumps = new PImage[2][3][8];
   
    loadSprites(idles[LEFT], idles_src[LEFT]);
    loadSprites(idles[RIGHT], idles_src[RIGHT]);
    loadSprites(runs[LEFT], runs_src[LEFT]);
    loadSprites(runs[RIGHT], runs_src[RIGHT]);
    loadSprites(jumps[LEFT], jumps_src[LEFT]);
    loadSprites(jumps[RIGHT], jumps_src[RIGHT]);
 }
  
 private void loadSprites(PImage[][] sprites, PImage[] src){
    for (int i = 0; i < src.length; ++i){
      int tempX = 0;
    
      for (int j = 0; j < sprites[i].length; ++j){
    
        sprites[i][j] = src[i].get(tempX, 0, 32, 32);
        tempX += 32;
      }
    }
 }
  
  
 private void displayAction(PImage[][][] sprites){
   changeFrame(sprites[direction][char_id]);
   
   
   // Image is larger than the character hitbox,
   // must fix object's position by adjusting x & y values.   
   float imgX = x - imageWidth / 5;
   float imgY = y - imageHeight / 6;
   image(current_frame, imgX, imgY, imageWidth, imageHeight);   
 }
 
 private void changeFrame(PImage[] sprites){
   
   // Delay is increased if it's jump animation.
   int delay = (isInAir) ? this.DELAY * 3 : this.DELAY;
   
   if (frameCount % delay == 0){
     frame_id++;
   }
   
   frame_id %= sprites.length;
   current_frame = sprites[frame_id];
 }
  
 private void displayIdle(){
   displayAction(idles);
 }
 
  private void displayRun(){
    displayAction(runs);
 }
 
 private void displayJump(){
   displayAction(jumps);
 }
  
 
 void switchCharacter(){
   if (key == 'q' || key == 'Q'){
     char_id = (char_id == 0) ? CHAR_COUNT : char_id - 1;
   }
   else if (key == 'e' || key == 'E'){
     char_id = (char_id == CHAR_COUNT) ? 0 : char_id + 1;
   }
   
   switch (char_id){
     case 0:
       maxVelocity = SPEED_MAX * 1.01;
       maxJump = JUMP_MAX * 1.01;
       break;
     case 1:
       maxVelocity = SPEED_MAX * 1.25;
       maxJump = JUMP_MAX / 2;
       break;
     case 2:
       maxVelocity = SPEED_MAX / 2;
       maxJump = JUMP_MAX * 1.2;
       break;
   }
 }
 
  
 void jump(){
   isInAir = true;
   velocityY = maxJump / 4;
 }
 
 void move(){
   x += velocityX; 
   y -= velocityY;
   
   if (isInAir){
     velocityY -= GRAVITY;
     velocityY = constrain(velocityY, -65, maxJump);
   }
   
   blockCollisionCheck();
   collectiblesCheck(collectibles);
 }
 
 private void collectiblesCheck(Collectible collectibles[]){
   for (Collectible c : collectibles){
     collisionRule(player, c);
   }
 }
 
 private void blockCollisionCheck(){
   
   boolean wasDown = false;
   
   for (Block b : blocks){
     int temp = collisionRule(player, b);
     
     if (temp == DOWN){
       wasDown = true;
       collision = temp;
     }
     else if (wasDown && temp == NONE){;}
     else {
       collision = temp;
     }
  
     adjustSpeedAfterCollision(wasDown);
   }
   adjustSpeedIfWorldEdge();   
  }
 
 private void adjustSpeedIfWorldEdge(){
   if (x < 0){
     x = 0;
     velocityX = 0;
   }
   
   if (w + x > world.w){
     velocityX = 0;
     x = world.w - w;
   }
   
   if (y < 0){
      y = 0;
      velocityY = 0;
   }
   
   if (h + y >= world.h){
       y = world.h - h;
       isInAir = false;
       velocityY = 0;
   }
       
   
 }
 
 private void adjustSpeedAfterCollision(boolean wasDown){
   
   if (collision == DOWN && velocityY <= 0){
     isInAir = false;
     velocityY = 0;
   }
   else if(collision == TOP && velocityY > 0 ){
     velocityY = 0;
   }
   else if (collision == LEFT && velocityX <= 0){
     velocityX = 0;
   }
   else if (collision == RIGHT && velocityX >= 0){
     velocityX = 0;
   }
   
   if (!wasDown){
     isInAir = true;
   }

 }
 
 void idle(){
   velocityX *= FRICTION;
   
   move();
   
   if (isInAir){
     displayJump();
   }
   else {
     displayIdle();
   }
   
   
 }
 
 void run(){
   if (direction == RIGHT){
     velocityX += accX;
   }
   else{
     velocityX -= accX;
   }
   velocityX = constrain(velocityX, -maxVelocity, maxVelocity);
   
   
   move();


   if (isInAir){
     displayJump();
   }
   else {
     displayRun();
   }
   
 }


 
 void display(){
     boolean isRight =  keys['d'] || keys['D'];
     boolean isLeft = keys['a'] || keys['A'];
     boolean isUp = keys['w'] || keys['W'];
     
     if(isUp && !isInAir){
       player.jump();
       
       // Force user to press jump button again
       // instead of autojumping while holding jump button.
       keys['w'] = false;
       keys['W'] = false;
     }
     
     if (isRight && !isLeft){
       direction = RIGHT;
       run();
     }
     else if (isLeft && !isRight){
       direction = LEFT;
       run();
     }
   else{
     idle();
   }
   
 }
 
 public void debugerStatus(){
   textSize(20);
   textAlign(LEFT);
   fill(0);
   
   String vely = "VelocityY: " + velocityY;
   String velx = "VelocityX: " + velocityX;
   String posx = "PosX: " + x;
   String posy = "PosX: " + y;
   String coll = "Col: " + collision;
   String air = "Air: " + isInAir;
   String cns = "Coins: " + coins;
   text(velx, 20, 20);
   text(vely, 20, 40);
   text(posx, 20, 60);
   text(posy, 20, 80);
   text(coll, 20, 100);
   text(air, 20, 120);
   text(cns, 20, 140);
   text("Mode: " + mode, 20, 160);
   text("Level: " + currentLevel, 20, 180);
   text("Framex: " + playerCam.frame.x, 20, 200);
   text("Framey: " + playerCam.frame.y, 20, 220);
 }

}
