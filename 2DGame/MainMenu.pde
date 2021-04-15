final int MENU = 0;
final int PLAY = 1;
final int EDIT = 2;
final int INFO = 3;
final int OPTIONS = 4;
final int RESTART = 5;
final int NEXTLEVEL = 6;
final int DEATH = 7;
final int FINISH = 8;

public class MainMenu{
  private Button play;
  private Button edit;
  private Button info;
  
  private boolean isShown;
  
  public MainMenu(String name1, String name2, String name3){
    int bHeight = 100;
    int bWidth = 300;
    int y = 100;
    int x = width / 2 - bWidth / 2;
    int space = bHeight + 100;
    play = new Button(x, y, bWidth, bHeight, name1);
    edit = new Button(x, y + space, bWidth, bHeight, name2);
    info = new Button(x, y + space * 2, bWidth, bHeight, name3);
    
    isShown = true;
  }
  
  public MainMenu(){
    this("PLAY", "EDIT", "INFO");
  }
  
  public int whichClicked(){
    
    if (play.isClicked()){
      return PLAY; 
    }
    if (edit.isClicked()){
      return EDIT;
    }
    if (info.isClicked()){
      return INFO;
    }
    
    return MENU;
  }
  
  public void hide(){
    isShown = false;
  }
  
  public void show(){
    isShown = true;
  }
  
  public boolean isShown(){
    return isShown;
  }
  
  private void displayEditandInfo(){
    edit.display();
    info.display();
  }
  
  private void displayButtons(){
    play.display();
    displayEditandInfo();
  }
  
  public void display(){
    image(background, 0, 0, worldSize.w, worldSize.h);
    displayButtons();
  }
  
  
}
