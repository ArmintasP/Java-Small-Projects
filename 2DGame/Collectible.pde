static int coins = 0;

public class Collectible extends Block{
  
  private PImage[] sprites;
  private int delay = 5;
  private int frame_id = 0;
  private Block image;
  private boolean isCollected;
  
  
  Collectible(Block b, PImage spritesSrc, int spritesLength){
    super(b.x, b.y, b.w, b.h, b.type, b.texture);
    this.image = new Block(b.x, b.y, b.w, b.h, b.type, b.texture);
    loadSprites(spritesSrc, spritesLength);
    
    this.isCollected = false;
    coins++;
  }
  
  private void loadSprites(PImage spritesSrc, int spritesLength){
      int tempX = 0;
      sprites = new PImage[spritesLength];
      for (int i = 0; i < spritesLength; ++i){
        
        sprites[i] = spritesSrc.get(tempX, 0, 64, 64);
        tempX += 64;
      }
    }
  
  @Override
  void display(){
    if (frameCount % delay == 0){
      frame_id++;
      frame_id %= sprites.length;    
    }
    
    if (!isCollected){
      image(sprites[frame_id], image.x, image.y, image.w, image.h);
    }
  }
  
  void hide(){
    coins--;
    isCollected = true;
  }
  
}
