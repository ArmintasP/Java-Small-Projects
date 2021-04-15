package fxextensions.fields;


public class MonthTextField extends IntegerNumberField {
    @Override
    protected boolean isNumber(String number) {
        return number.matches("(1[0-2]?|[0-9])");
    }

}
