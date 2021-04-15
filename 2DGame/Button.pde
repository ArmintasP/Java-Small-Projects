public class Button{
  private int x;
  private int y;
  private int w;
  private int h;
  private String name;
  private int fontSize = 32;
  private PFont font;
  private int strokeWidth;
  
  public Button(int x, int y, int w, int h, String name, int strokeWidth){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.name = name;
    this.font = createFont("Arial", this.fontSize);
    this.strokeWidth = strokeWidth;
  }
  
  public Button(int x, int y, int w, int h, String name){
    this(x, y, w, h, name, 16);
  }
  
  public boolean isClicked(){
    if (mousePressed){
      if (isHovering()){
        return true;
      }
    }
    return false;
  }
  
  public boolean isHovering(){
    if (mouseX >= x && mouseX < x + w &&  mouseY >= y && mouseY < y + h){
      return true;
    }
    return false;
  }
  
  public void display(){
    
    if (isHovering()){
      fill(214,59,126);
    }
    else {
      fill(255,64,64);     
    }
    stroke(255);
    strokeWeight(strokeWidth);
    
    rect(x, y, w, h);
    strokeWeight(1);
    
    
    fill(255);
    
    textFont(font);
    textAlign(CENTER);
    text(name, x, y + (h - fontSize) / 2, w, h / 2);
  }
  
}
