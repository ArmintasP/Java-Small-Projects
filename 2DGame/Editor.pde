public class Editor{
  // Map size.
  final int xSize = 40;
  final int ySize = 40;
  
  
  final int blockSize = 16;
  
  private int coins;
  
  
  private boolean hasPlayer;
  private int playerX;
  private int playerY;
  
  private int currentTile;
  
  private Table mapData;
  private String mapName;
  private String[] mapNames;
  
  private Button[] levels;
  private Button saveButton;
  
  public Editor(String[] mapNames){
    this.mapName = mapNames[0];
    this.mapNames = mapNames;
    this.mapData = loadTable(this.mapName);
    
    this. coins = 0;
    this.levels = new Button[MAXLEVEL];
    
    int i;
    for(i = 0; i < MAXLEVEL; ++i){
      Button b = new Button(8 + xSize * blockSize, 16 + i * 100, 160, 80, "LEVEL " + (i + 1), 8);
      this.levels[i] = b;
    }
    saveButton = new Button(8 + xSize * blockSize, 16 + i * 100, 160, 80, "SAVE", 8);
  }
  
  void reload(int id){
    mapName = mapNames[id];
    mapData = loadTable(this.mapName);
    coins = 0;
    playerX = -1;
    playerY = -1;
    hasPlayer = false;
  }
  
  
  void display(){
    
    displayMap();
    displayTiles();
    displayButtons();
    
    if (canSave() && saveButton.isClicked()){
      saveTable(mapData, "data/" + mapName);
    }
    
    changeLevelIfClicked();
  }
  
  
  private void changeLevelIfClicked(){
    for (int i = 0; i < levels.length; ++i){
      if (levels[i].isClicked()){
        reload(i);
      }
    } 
  }
  
  private void displayButtons(){
    for (Button b : levels){
      b.display();
    }
    saveButton.display();
  }
  
  
  private boolean canSave(){
    boolean b = true;
    fill(220, 20, 60, 150);
    noFill();
    if (coins <= 0){
      text("Map cannot be saved, add at least 1 coin", width / 2, height - 75);
      b = false;
    }
    if (!hasPlayer){
      text("Map cannot be saved, add a player", width / 2, height - 25);
      b = false;
    }
    return b;
  }
  
  
  private void addTile(int x, int y){
    mapData.setInt(x, y, currentTile);
  }
  
  private void removeTile(int x, int y){
    mapData.setInt(x, y, -1);
  }
  
  
  private boolean isHovering(int x, int y){
    if (mouseX >= x && mouseX < x + blockSize &&  mouseY >= y && mouseY < y + blockSize){
      return true;
    }
    return false;
  }
  
  private boolean isClicked(int x, int y){
    if (mousePressed){
      if (isHovering(x, y)){
        return true;
      }
    }
    return false;
  }
  
  
  private void displayMap(){
    image(background, 0, 0, worldSize.w, worldSize.h);
    strokeWeight(1);
    noFill();
    
    coins = 0;
    
    
    for (int i = 0; i < ySize; ++i){
      for (int j = 0; j < xSize; ++j){
        
        rect(j * blockSize, i * blockSize, blockSize, blockSize);
        int id = mapData.getInt(i, j);
        
        if (id == 255){
          coins++;
        }
        
        if (id == 254){
          if (hasPlayer && (playerX != j || playerY != i)){
            removeTile(playerY, playerX);
          }
          
          hasPlayer = true;
          playerX = j;
          playerY = i;
        }
                
         if (isClicked(i * 16, j * 16)){
           if (playerX == i && playerY == j && currentTile != 254){
              hasPlayer = false;
              playerX = -1;
              playerY = -1;
           }
           
          addTile(j, i);
        }
        
        if (id < 0){
          displaySelection(j * 16, i * 16, true);
          continue;
        }
        
        PImage img = tileset[id];
        image(img, j * blockSize, i * blockSize, blockSize, blockSize);
        
        displaySelection(j * 16, i * 16, true);
      }
    }
  }
  
  void displaySelection(int x, int y, boolean map){
    if (isHovering(x, y)){
      if (map){
        image(tileset[currentTile], x, y, blockSize, blockSize);
      }
      
      fill(220, 20, 60, 150);
      rect(x, y, blockSize, blockSize);
      noFill();
      

    }
    return ;
  }
  
  void displayTiles(){
    int y = 400 - blockSize * 3;
    int x = width - 17 * blockSize- blockSize;
    
    noFill();
    strokeWeight(blockSize);
    rect(x + blockSize / 2, y + blockSize / 2, 17 * blockSize, 17 * blockSize);
    strokeWeight(1);
    
    for (int i = 0; i < tileset.length; ++i){
      PImage img = tileset[i];

      if (i % 16 == 0){
        y += 16;
        x = width - 17 * blockSize- blockSize;
      }
      x += blockSize;
      image(img, x, y, blockSize, blockSize);
      
      displaySelection(x, y, false);
      
      if (isClicked(x, y)){
        currentTile = i;
      }
    }
    
  }
  
  
  
}
