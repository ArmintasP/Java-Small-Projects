package fxextensions.fields;

import javafx.geometry.Pos;
import javafx.scene.control.TextField;

public class DoubleNumberField extends TextField {

    public DoubleNumberField() {
        super.setAlignment(Pos.CENTER_RIGHT);
    }

    @Override
    public void replaceText(int start, int end, String number) {
        String newNumber = super.getText() + number;

        if (isNumber(newNumber)) {
            super.replaceText(start, end, number);
        }
    }

    @Override
    public void replaceSelection(String number) {
        String newNumber = super.getText() + number;
        if (isNumber(newNumber)) {
            super.replaceSelection(number);
        }
    }

    protected boolean isNumber(String number) {
        return number.matches("\\d*\\.?\\d?\\d?");
    }
}
