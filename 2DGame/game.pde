/**
 * A game that has three unique characters.
 * If player collects all coins from all levels,
 * he wins the game.
 *
 * @author Armintas Pakenis, MIF PS 1 kursas, 1 grupė, 1 pogrupis.
*/

import ddf.minim.*;



static final int BACKGROUND = 0;
static final int SOLID = 1;
static final int DEADLY = 2;
static final int COLLECTABLE = 3;
static final int ENEMY = 4;
static final int AIR = 5;


final int LEFT = 0;
final int RIGHT = 1;
final int TOP = 2;
final int DOWN = 3;
final int NONE = 99;


int currentLevel;
final int MAXLEVEL = 5;
String[] mapNames = {"mapZERO.csv", "mapONE.csv", "mapTWO.csv", "mapTHREE.csv", "mapFOUR.csv"};



PImage[][] idles_src = new PImage[2][3];
PImage[][] runs_src = new PImage[2][3];
PImage[][] jumps_src = new PImage[2][3];
PImage tileset_src;
PImage[] tileset = new PImage[16 * 16];
PImage background;

boolean[] keys = new boolean[65536];


// Size of blocks, can be adjusted for better graphics.
final int blockSize = 64;


int mode;
Button optionsButton;
Button nextLevelButton;
Button finishButton;
Button backButton;
Player player;
Block[] blocks;

Collectible[] collectibles;


Table mapData;

Screen worldSize;
Camera playerCam;
Editor editor;

MainMenu menu;
Options options;


void playSong(){
  Minim minim;
  AudioPlayer song;
  minim = new Minim(this);
  song = minim.loadFile("song.mp3");
  song.loop();
}


void setup(){
  
  
  //playSong();
  
  loadImages();
  
  currentLevel = 0;
  loadWorld();
  
  
  nextLevelButton = new Button((width - 257) / 2, height - height / 3, 250, 150, "NEXT LEVEL");
  finishButton = new Button((width - 257) / 2, height - height / 3, 250, 150, "FINISH GAME");
  optionsButton = new Button(width - 207, 7, 200, 80, "OPTIONS");
  backButton = new Button(width - 207, 7, 200, 80, "BACK");
  
  editor = new Editor(mapNames);
  options = new Options();
  menu = new MainMenu();
  mode = MENU;
  
  size(1200, 800, P2D);
}

void loadWorld(){
  loadMapData(mapNames[currentLevel]);
  //player = new Player(worldSize, 300, 000);
  playerCam = new Camera(worldSize);
}

void loadMapData(String mapName){
  coins = 0;
  player = new Player(worldSize, 0, 0);
  mapData = loadTable(mapName);
  int rows = mapData.getRowCount();
  int cols = mapData.getColumnCount();
  
  worldSize = new Screen(0, 0, cols * blockSize, rows * blockSize);
  
  Block[] temp_blocks = new Block[rows * cols];
  Collectible[] temp_collectibles = new Collectible[rows * cols];
  
  
  int actualBlockCount = 0;
  int actualCollectibleCount = 0;
  
  for (int i = 0; i < rows; ++i){
    for (int j = 0; j < cols; ++j){
      int tileID = mapData.getInt(i, j);
      
      int tileType = tileType(tileID);
      
      if (tileType == AIR){
        continue;
      }
      
      PImage img = tileset[tileID];
      Block b = new Block(j * blockSize, i * blockSize,
                             blockSize, blockSize, tileType, img);
                             
      if (tileID == 254){
        player = new Player(worldSize, j * blockSize, i * blockSize);
        continue;
      }
                             
                             
      if (tileType == SOLID || tileType == DEADLY || tileType == BACKGROUND){
        
         temp_blocks[actualBlockCount] = b;
         actualBlockCount++;
      }
      
      
      if (tileType == COLLECTABLE){
        PImage coinsSrc = loadImage("coins64.png");
        int coinsLength = 8;
        
        Collectible c = new Collectible(b, coinsSrc, coinsLength);
        temp_collectibles[actualCollectibleCount] = c;
        actualCollectibleCount++;
      }
    }
  }
  
  blocks = new Block[actualBlockCount];
  collectibles = new Collectible[actualCollectibleCount];
  
  for (int i = 0; i < actualBlockCount; ++i){
    blocks[i] = temp_blocks[i];
  }
  
  for (int i = 0; i < actualCollectibleCount; ++i){
    collectibles[i] = temp_collectibles[i];
  }
  
}

void loadImages(){
  tileset_src = loadImage("tiles.png");
  for (int i = 0; i < 16; ++i){
    for (int j = 0; j < 16; ++j){
          tileset[16 * i + j] = tileset_src.get(j * 64, i * 64, 64, 64);
    }
  }
  
  background = loadImage("gradient.jpg");
  
  loadImages(idles_src[LEFT], "idleL");
  loadImages(idles_src[RIGHT], "idleR");
  loadImages(runs_src[LEFT], "runL");
  loadImages(runs_src[RIGHT], "runR");
  loadImages(jumps_src[LEFT], "jumpL");
  loadImages(jumps_src[RIGHT], "jumpR");
}

void loadImages(PImage[] array, String keyword){

  for (int i = 0; i < array.length; ++i){
    String filename = keyword + i + ".png";
    array[i] = loadImage(filename);
  }
}



// Collision rule also changes coordinates of
// a player if it touches a block. In addition,
// it returns integer value, which indicates,
// which side did the player collide with.

int collisionRule(Player p, Block b){
  
  
  if (b.type == BACKGROUND) return NONE;
  
  // Distance from centers
  float diffX = (p.x + p.w / 2.0) - (b.x + b.w / 2.0);
  float diffY = (p.y + p.h / 2.0) - (b.y + b.h / 2.0);
  
  // Minimal distance when Player and Block does not collide.
  float w = p.w / 2.0 + b.w / 2.0;
  float h = p.h / 2.0 + b.h / 2.0;
  
  // Absolute value is used when comparing diffX/Y
  // with appropriate minimal distance.
  float diffXabs = abs(diffX);
  float diffYabs = abs(diffY);
  
  
  if (diffXabs < w){

    
    if (diffYabs < h){
      if (b.type == COLLECTABLE){
        Collectible c = (Collectible) b;
        if (c.isCollected == false){
          c.hide();
        }
        return NONE;
      }
      
      if (b.type == DEADLY){
        mode = DEATH;
      }
      
      float fixX = w - diffXabs - 0.0001;
      float fixY = h - diffYabs - 0.0001;
      
      // Velocity might be large, thus comparing
      // length is more accurate based on time.
      float timeX = (abs(p.velocityX) > 0) ? fixX / abs(p.velocityX) : fixX;
      float timeY = (abs(p.velocityY) > 0) ? fixY / abs(p.velocityY) : fixY;
      
      if (timeY <= timeX){
        if (diffY > 0){
          p.y += fixY;
          return TOP;
        }
        else{
          p.y -= fixY;
          return DOWN;
        }
      }
      else{
        if (diffX > 0){
          p.x += fixX;
          return LEFT;
        }
        else{
          p.x -= fixX;
          return RIGHT;
        }
      }
    }
  }
  return NONE;
}


void draw(){
  
  if (mode == MENU){
    menu.display();
    
    if(menu.whichClicked() == MENU){
      ;
    }
    else{
      menu.hide();
      mode = menu.whichClicked();
      delay(100);
    }
    
  }
  else{
    switch (mode){
      case PLAY:
      case NEXTLEVEL:
      case FINISH:
        playGame();
      break;
      
      case OPTIONS:
        options.display();
        optionsChoice();
      break;
      
      case DEATH:
        options.displayDeath();
        optionsChoice();
      break;
      
      
      case EDIT:
        editor.display();
        backButton.display();
        
        if (backButton.isClicked()){
          mode = MENU;
          editor.reload(0);
          loadWorld();
        }
      break;
      
      case INFO:
        image(background, 0, 0, worldSize.w, worldSize.h);
        fill(255,64,64);
        textSize(50);
        text("Controls", width / 2, height / 10);
        text("Q, E - change character.", width / 2, height / 10 * 3);
        text("W, A, D - move your character.", width / 2, height / 10 * 6);
        text("Author: Armintas Pakenis.", width / 2, height / 10 * 9);
        backButton.display();
        if (backButton.isClicked()){
          mode = MENU;
        }
      break;
    }
    
  }
  
  //playGame();

    
}

void optionsChoice(){
  int choice = options.whichClicked();
  
  if (choice == PLAY && mode != DEATH){
    if (coins == 0){
      if (currentLevel >= MAXLEVEL){
        mode = FINISH;
      }
      else{
        mode = NEXTLEVEL;
      }
    }
    else {
      mode = PLAY;
    }
  }
  else if(choice == MENU){
    // Resets progress.
    currentLevel = 0;
    loadWorld();
    
    mode = MENU;
    menu.show();
    delay(200);
  }
  else if (choice == RESTART){
    if (coins == 0){
      currentLevel--;
    }
    mode = PLAY;
    loadWorld();
    
    
  }
  
}

void playGame(){
  
  playerCam.moveCamera(player);
  
  pushMatrix();
  
  translate(-playerCam.frame.x, -playerCam.frame.y);
  image(background, 0, 0, worldSize.w, worldSize.h);
  
  displayArray(blocks);
  displayArray(collectibles);
  
  player.display();
  
  popMatrix();
  
  optionsButton.display();
  

  
  if (coins == 0 && mode != DEATH){
    displayNextLevel();
  }
  
  if (optionsButton.isClicked()){
    mode = OPTIONS;
  }

  //player.debugerStatus();
}


void displayNextLevel(){
  
  if (mode == NEXTLEVEL){
    nextLevelButton.display();
    
    if (nextLevelButton.isClicked()){
        loadWorld();
        mode = PLAY;
    }
  }
  else if (mode == FINISH){
    finishButton.display();
    
    if (finishButton.isClicked()){
    currentLevel = 0;
    loadWorld();
    
    mode = MENU;
    menu.show();
    delay(200);
    }
  }
  else{
    
    currentLevel++;
    
    if (currentLevel >= MAXLEVEL){
      mode = FINISH;
    }
    else{
      mode = NEXTLEVEL;
    }
  }
}

void displayArray(Block[] array){
  for (int i = 0; i < array.length; ++i){
    array[i].display();
  }
}

void keyPressed(){
    keys[key] = true;
}

void keyReleased(){
    player.switchCharacter();
    keys[key] = false;
}
