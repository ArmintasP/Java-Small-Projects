package fxextensions.panes;

import javafx.collections.ObservableList;
import javafx.geometry.HPos;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Label;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.text.Font;
import javafx.scene.text.FontPosture;
import javafx.scene.text.FontWeight;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

import java.io.File;
import java.io.PrintWriter;

public class Table extends GridPane {
    private int rowCount;
    ChoiceBox<Integer> cbFrom;
    ChoiceBox<Integer> cbTo;

    public Table() {
        this(new String[]{"Payment id", "Installment", "Loan repayment", "Interest amount", "Loan Balance"});
    }


    private Table(String[] headers) {

        setupFilterMenu();





        for (int i = 0; i < headers.length; ++i) {
            Label l = new Label(headers[i]);
            l.setFont(Font.font("Times New Roman", FontWeight.BOLD, FontPosture.REGULAR, 14));
            super.add(l, i, 1);
        }
        setAlignment(Pos.CENTER);
        setMinWidth(550);
        super.setHgap(20);

        this.rowCount = 2;
    }



    private void choiceAction() {
        ObservableList<Integer> items = cbFrom.getItems();
        int val = cbFrom.getSelectionModel().getSelectedIndex();
        items.clear();

        for (int i = 1; i <= cbTo.getValue(); ++i) {
            items.add(i);
        }
        cbFrom.getSelectionModel().selectFirst();
        if (val > 0) {
            cbFrom.getSelectionModel().select(val);
        }
    }



    private void setupFilterMenu() {
        Label l1 = new Label("From (id):");
        l1.setAlignment(Pos.CENTER);
        Label l2 = new Label("To (id): ");
        l2.setAlignment(Pos.CENTER);

        HBox h = new HBox();
        h.setSpacing(10);
        h.setPadding(new Insets(10, 0, 20, 0));

        cbFrom = new ChoiceBox<>();
        cbTo = new ChoiceBox<>();
        cbTo.setOnAction(e -> choiceAction());


        Button btFilter = new Button("Filter");
        btFilter.setOnAction(e -> filterButtonAction());



        h.getChildren().addAll(l1, cbFrom, l2, cbTo, btFilter);

        this.add(h, 0, 0, 3, 1);
    }



    private void filterButtonAction() {
        if (cbFrom.getSelectionModel().isEmpty()) return;
        if (cbTo.getSelectionModel().isEmpty()) return;

        int from = cbFrom.getSelectionModel().getSelectedItem();
        int to = cbTo.getSelectionModel().getSelectedItem();

        filter(from, to);
    }



    private void filter(int from, int to) {
        ObservableList<Node> children = this.getChildren();

        for (int i = 6; i < children.size(); ++i) {
            children.get(i).setManaged(true);
            children.get(i).setVisible(true);
        }

        for (int i = (to + 1) * 5 + 1; i < children.size(); ++i) {
            children.get(i).setManaged(false);
            children.get(i).setVisible(false);
        }
        for (int i = 6; i < from * 5 + 1; ++i) {
            children.get(i).setManaged(false);
            children.get(i).setVisible(false);
        }
    }



    public void addRow(Object[] objects) {

        for (int i = 0; i < objects.length; ++i) {
            Label l = new Label((String) objects[i]);
            Table.setHalignment(l, HPos.RIGHT);
            l.setFont(Font.font("Times New Roman", 12));

            this.add(l, i, rowCount);
        }

        cbFrom.getItems().add(rowCount - 1);
        cbTo.getItems().add(rowCount - 1);

        rowCount++;
    }


    private File chooseFile(){
        FileChooser fileChooser = new FileChooser();
        fileChooser.setInitialFileName("Loan.txt");

        FileChooser.ExtensionFilter filter = new FileChooser.ExtensionFilter("TXT files (*.txt)", "*.txt");
        fileChooser.getExtensionFilters().add(filter);

        return fileChooser.showSaveDialog(new Stage());
    }

    private void save(boolean saveAll) {
        File file = chooseFile();

        try (PrintWriter writer = new PrintWriter(file)) {
            ObservableList<Node> nodes = getChildren();

            for (int i = 1; i < nodes.size(); ++i) {
                Node n = nodes.get(i);

                if (!saveAll && !n.isVisible()) {
                    continue;
                }

                String s = ((Label)n).getText();
                writer.printf("%25s ", s);

                if (i % 5 == 0) {
                    writer.println();
                }

            }


        }
        catch (Exception e) {
            Alert a = new Alert(Alert.AlertType.ERROR);
            a.setTitle(null);
            a.setHeaderText("ERROR!");
            a.setContentText("Could not save file!");
            a.showAndWait();
        }

    }


    public void saveAll() {
        save(true);
    }

    public void saveFiltered() {
        save(false);
    }
}
