public class Screen{
  float x;
  float y;
  float w;
  float h;
  
  Screen(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  private Screen(){}
}

public class Camera{
  Screen frame;
  Screen world;
  
  public Camera(Screen world){
    float x = world.x + world.w / 2 - width / 2;
    float y = world.y + world.y / 2 - height / 2;
    this.frame = new Screen(x, y, width, height);
    this.world = world;
  }
  
  public void moveCamera(Player p){
    frame.x = p.x + p.w / 2 - frame.w / 2;
    frame.y = p.y + p.h / 2 - frame.h / 2;
    
    frame.x = (world.x > frame.x) ? world.x : frame.x;
    frame.y = (world.y > frame.y) ? world.y : frame.y;
    
    if (frame.w + frame.x > world.w + world.x){
      frame.x = world.w + world.x - frame.w;
    }
    if (frame.h + frame.y > world.h + world.y){
      frame.y = world.h + world.y - frame.h;
    }
    
  }
  
}
