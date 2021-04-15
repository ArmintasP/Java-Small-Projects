package fxextensions.panes;

import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.layout.StackPane;
import javafx.util.StringConverter;

public class Graph extends StackPane {
    XYChart.Series<Number, Number> installment;
    XYChart.Series<Number, Number> interest;
    XYChart.Series<Number, Number> loanRepayment;

    public Graph() {
        NumberAxis hAxis = new NumberAxis();

        NumberAxis vAxis = new NumberAxis();
        configureAxis(hAxis, vAxis);

        LineChart<Number, Number> lChart = new LineChart<>(hAxis, vAxis);

        installment = new XYChart.Series<>();
        installment.setName("Installment");

        interest = new XYChart.Series<>();
        interest.setName("Interest");

        loanRepayment = new XYChart.Series<>();
        loanRepayment.setName("Loan repayment");

        lChart.getData().add(installment);
        lChart.getData().add(interest);
        lChart.getData().add(loanRepayment);

        this.getChildren().add(lChart);
    }

    private void configureAxis(NumberAxis hAxis, NumberAxis vAxis) {
        vAxis.setLabel("Amount, €");
        hAxis.setLabel("Payment id");


        hAxis.setAutoRanging(true);
        hAxis.tickUnitProperty().set(2);
        hAxis.setLowerBound(1);
        hAxis.setTickUnit(2);

        hAxis.setMinorTickVisible(false);
        hAxis.setTickLabelFormatter(new IntegerFormat());
        hAxis.setForceZeroInRange(false);

    }

    public void addData(String[] data) {
        int id = Integer.parseInt(data[0]);

        installment.getData().add(new XYChart.Data<>(id, Double.valueOf(data[1])));
        loanRepayment.getData().add(new XYChart.Data<>(id, Double.valueOf(data[2])));
        interest.getData().add(new XYChart.Data<>(id, Double.valueOf(data[3])));

    }
}

class IntegerFormat extends StringConverter<Number> {

    @Override
    public String toString(Number number) {
        if (number.doubleValue() != number.intValue()){
            return "";
        }

        return Integer.toString(number.intValue());
    }

    @Override
    public Number fromString(String s) {
        return (int) Double.parseDouble(s);

    }
}


