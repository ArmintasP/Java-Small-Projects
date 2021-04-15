

public class Block extends Object{
  float x;
  float y;
  int w;
  int h;
  int type;
  PImage texture;
  
  Block(float x, float y, int w, int h, int type, PImage texture){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;    
    this.type = type;
    this.texture = texture;
  }
  
  void display(){
    image(texture, x, y, w, h);
  }
  
  void hide(){
  }
  
}

  
static int tileType(int tileID){
  int tile_type;
  
  if (tileID == -1){
    tile_type = AIR;
  }
  else if (tileID >= 160 && tileID <= 175){
    tile_type = DEADLY;
  }
  else if (tileID > 175 && tileID < 255){
    tile_type = BACKGROUND;
  }
  else if (tileID == 255){
    tile_type = COLLECTABLE;
  } 
  else{
    tile_type = SOLID;
  }
  return tile_type;
}
