public class Options extends MainMenu{
    
  public Options(){
    super("RESUME", "RESTART", "EXIT");
  }
  
  @Override
  public int whichClicked(){
    int state = super.whichClicked();
    
    if (state == PLAY){
      return PLAY; 
    }
    if (state == EDIT){
      return RESTART;
    }
    if (state == INFO){
      return MENU;
    }
    
    return OPTIONS;
  }
  
  @Override
  public void display(){
    fill(0, 0, 0, 10);
    rect(0, 0, width, height);
    super.displayButtons();
  }
  
  public void displayDeath(){
    fill(0, 0, 0, 50);
    rect(0, 0, width, height);
    fill(255, 255, 255);
    super.displayEditandInfo();
    textSize(64);
    text("YOU HAVE DIED.", width / 2, 250);
  }
  
  
}
