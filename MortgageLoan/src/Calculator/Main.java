package Calculator;


import fxextensions.panes.CalculatorPane;


import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;


public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        try {
            GridPane pane = new CalculatorPane();


            Scene scene = new Scene(pane, 800, 800);
            primaryStage.setHeight(800);

            primaryStage.setTitle("Mortgage Calculator");
            primaryStage.setScene(scene);
            primaryStage.show();
        }
        catch (Exception e){
            throw new Exception();
        }
    }

    public static void main(String[] args) {
        launch(args);
    }
}


