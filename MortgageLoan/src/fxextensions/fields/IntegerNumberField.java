package fxextensions.fields;

public class IntegerNumberField extends DoubleNumberField {

    @Override
    protected boolean isNumber(String number) {
        return number.matches("\\d*");
    }

}
