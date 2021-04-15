package fxextensions.panes;

import fxextensions.fields.*;
import javafx.geometry.HPos;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.Background;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import Calculator.*;
import javafx.stage.Stage;

public class CalculatorPane extends GridPane {

    public CalculatorPane() {

        super.setHgap(25);
        super.setVgap(15);
        super.setPadding(new Insets(15));
        super.setAlignment(Pos.CENTER);


        DoubleNumberField tfLoanAmount = new DoubleNumberField();
        addWithLabel(new Label("Loan amount:"), tfLoanAmount, 0);


        IntegerNumberField tfNumberOfYears = new IntegerNumberField();
        addWithLabel(new Label("Number of years:"), tfNumberOfYears, 1);


        MonthTextField tfNumberOfMonths = new MonthTextField();
        addWithLabel(new Label("Number of months:"), tfNumberOfMonths, 2);


        RadioButton rAnnuity = new RadioButton("Annuity");
        RadioButton rLinear = new RadioButton("Linear");
        HBox radioButtonPane = createRadioButtonPane(rAnnuity, rLinear);
        addWithLabel(new Label("Mortgage type:"), radioButtonPane, 3);


        DoubleNumberField tfInterestRate = new DoubleNumberField();
        addWithLabel(new Label("Interest rate (%):"), tfInterestRate, 4);


        Button bCalculate = new Button("Calculate");
        super.add(bCalculate, 0, 5, 2, 1);
        GridPane.setHalignment(bCalculate, HPos.CENTER);


        ScrollPane sPane = new ScrollPane();
        sPane.setContent(new Table());
        //sPane.setFitToWidth(true);
        sPane.setMinWidth(600);
        sPane.setMinHeight(400);
        sPane.setBackground(Background.EMPTY);

        super.add(sPane, 0, 8, 2, 1);

        bCalculate.setOnAction(e -> {
            String m = tfNumberOfMonths.getText();
            String y = tfNumberOfYears.getText();
            int months = m.isEmpty() ? 0 : Integer.parseInt(m);
            months = y.isEmpty() ? months : months + Integer.parseInt(y) * 12;


            calculateLoan(tfLoanAmount.getText(), tfInterestRate.getText(), months, rLinear.isSelected(), sPane);
        });


    }

    private void addWithLabel(Label l, Node n, int row) {
        super.add(l, 0, row);
        super.add(n, 1, row);


    }

    private HBox createRadioButtonPane(RadioButton r1, RadioButton r2) {
        HBox radioButtonPane = new HBox();
        radioButtonPane.setSpacing(25);

        ToggleGroup tGroup = new ToggleGroup();

        r1.setToggleGroup(tGroup);
        r2.setToggleGroup(tGroup);

        r1.setSelected(true);
        r1.setAlignment(Pos.CENTER_LEFT);

        r2.setAlignment(Pos.CENTER_RIGHT);

        radioButtonPane.getChildren().addAll(r1, r2);

        return radioButtonPane;
    }

    private void calculateLoan(String amount, String interest, int months, boolean isLinear, ScrollPane sPane) {
        amount = amount.isEmpty() ? "0" : amount;
        interest = interest.isEmpty() ? "0" : interest;


        Table table = new Table();
        Loan loan;

        try {
            loan = new Loan(amount, interest, months);
        }
        catch (Exception e) {
            Alert a = new Alert(Alert.AlertType.WARNING);
            a.setTitle(null);
            a.setHeaderText("Attention!");
            a.setContentText("Do not leave amount, interest or period fields blank or set to 0!");
            a.showAndWait();
            return;
        }

        Graph graph = new Graph();

        if (isLinear) {
            loan.calculateMonthlyLinear(table, graph);
        } else {
            loan.calculateMonthlyAnnuity(table, graph);
        }

        showButtonsAfterCalculate(table, graph);

        sPane.setContent(table);
    }

    private void showButtonsAfterCalculate(Table table, Graph graph){

        HBox hBox = new HBox();
        hBox.setSpacing(25);

        Button btSaveFiltered = new Button("Export filtered");
        Button btSaveAll = new Button("Export everything");
        Button btGraph = new Button("Show Graph");

        hBox.getChildren().addAll(btGraph, btSaveFiltered, btSaveAll);
        this.add(hBox, 0, 7, 2, 1);
        hBox.setAlignment(Pos.CENTER);
        setHalignment(hBox, HPos.CENTER);

        btSaveAll.setOnAction(e -> table.saveAll());
        btSaveFiltered.setOnAction(e -> table.saveFiltered());

        Scene scene = new Scene(graph, 500, 500);
        btGraph.setOnAction(e -> showGraph(scene));
    }

    private void showGraph(Scene scene) {
        Stage stage = new Stage();
        stage.setScene(scene);
        stage.show();
    }
}
