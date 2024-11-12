/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newpackage;

import java.awt.Color;
import java.awt.Font;
import javax.swing.*;


abstract public class GUI_Helper {
    protected final JFrame mainframe        = new JFrame();
    protected final int[] windowSize        = {800, 220};

    //Enum für die Textmodi
    public enum mode {
        result,
        info,
        error
    }
    
    //Methoden die im Kind definiert werden
    abstract public void dropDownSelected(int id);
    
    abstract public void buttonPressed(int id);
    
    //Methoden zum erstellen von Objekten für das Panel
    protected final JTextField addTextField(String Text, int posX, int posY, int hSize, int bSize){
        JTextField textfeld = new JTextField();
        textfeld.setBounds(posX, posY, bSize, hSize);
        textfeld.setFont(new Font("Arial", Font.BOLD, 14));
        textfeld.setText(Text);
        return textfeld;
    }
    
    protected final JButton addButton(String Text, int posX, int posY, int id){
        JButton button = new JButton();
        int hsize = 20;
        button.setBounds(posX, posY, windowSize[0]/3, hsize);
        button.addActionListener(d -> buttonPressed(id));
        button.setText(Text);
        button.setBorder(BorderFactory.createEtchedBorder());
        button.setEnabled(true);
        //button.setIcon(icon);
        return button;
    }
    
    protected final JLabel addText(String Text, int posX, int posY, mode mode){
        JLabel text = new JLabel();
        text.setBounds(posX, posY, windowSize[0]/2+20, 60);
        text.setText(Text);
        text.setEnabled(true);
        switch (mode) {
            case result:
                text.setFont(new Font("Arial", Font.BOLD, 24));
                text.setBorder(BorderFactory.createEtchedBorder());
                break;
            case info:
                text.setFont(new Font("Arial", Font.PLAIN, 14));
                break;
            case error:
                text.setFont(new Font("Arial", Font.BOLD ,18));
                text.setForeground(Color.RED);
                break;
        }
        
        return text;
    }
    
    protected final JComboBox<String> addDropDown(String[] options, int posX, int posY, int id){
        JComboBox<String> dropdown = new JComboBox<>(options);
        dropdown.setBounds(posX, posY, windowSize[0]/3, 20);
        dropdown.addActionListener(e -> dropDownSelected(id));
        return dropdown;
    }
    
}
