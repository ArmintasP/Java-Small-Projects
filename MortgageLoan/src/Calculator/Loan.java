package Calculator;


import fxextensions.panes.Graph;
import fxextensions.panes.Table;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class Loan {
    private final BigDecimal loanAmount;
    private final int months;
    private final BigDecimal interest;


    public Loan(String loanAmount, String interest, int months) throws Exception{
        this(new BigDecimal(loanAmount),
             new BigDecimal(interest),
             months);
    }




    public Loan(BigDecimal loanAmount, BigDecimal interest, int months) throws Exception{
        this.loanAmount = loanAmount;
        this.months = months;

        try{
            this.interest = interest.divide(BigDecimal.valueOf(1200), 20, RoundingMode.UP);
            calculatePmt();
        }
        catch (ArithmeticException e){
            throw new Exception();
        }



        validate();

    }



    private void validate() throws Exception{
        if (interest.equals(BigDecimal.ZERO) || months == 0 || loanAmount.equals(BigDecimal.ZERO)) {
            throw new Exception();
        }
    }



    public BigDecimal calculatePmt(){

        BigDecimal interest2 = interest.add(BigDecimal.ONE).pow(months);

        BigDecimal numerator = loanAmount.multiply(interest.multiply(interest2));
        BigDecimal denumerator = interest2.subtract(BigDecimal.ONE);

        return numerator.divide(denumerator, 20, RoundingMode.CEILING);
    }


    public void calculateMonthlyAnnuity(Table table, Graph graph){

        BigDecimal pmt = calculatePmt();

        BigDecimal interestPart;
        BigDecimal payment;
        BigDecimal amount = loanAmount.add(BigDecimal.ZERO);



        for (int i = 0; i < months; ++i) {
            interestPart = amount.multiply(interest);
            payment = pmt.subtract(interestPart);

            storeDataToTable(table, graph, i + 1, pmt, interestPart, payment, amount);

            amount = amount.subtract(payment);
        }
    }



    public void calculateMonthlyLinear(Table table, Graph graph) {

        BigDecimal amount = loanAmount.add(BigDecimal.ZERO);
        BigDecimal payment = amount.divide(BigDecimal.valueOf(months), 17, RoundingMode.HALF_UP);

        BigDecimal pmt;
        BigDecimal interestPart;

        for (int i = 0; i < months; ++i) {
            interestPart = amount.multiply(interest);
            pmt = payment.add(interestPart);

            storeDataToTable(table, graph,i + 1, pmt, interestPart, payment, amount);

            amount = amount.subtract(payment);
        }

    }



    private void storeDataToTable(Table table, Graph graph, int id, BigDecimal pmt, BigDecimal interestPart, BigDecimal payment, BigDecimal amount){
        String[] data = new String[5];
        data[0] = String.format("%d", id);
        data[1] = String.format("%.2f", pmt);
        data[2] = String.format("%.2f", payment);
        data[3] = String.format("%.2f", interestPart);
        data[4] = String.format("%.2f", amount);

        table.addRow(data);
        graph.addData(data);
    }


}