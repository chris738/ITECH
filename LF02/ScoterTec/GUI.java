/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newpackage;

import java.awt.*;
import javax.swing.*;

public class GUI extends newpackage.GUI_Helper{

    private final String   title           = "Kosten Berrechnung";
    private final String[] defaultFeldText = { "0", "Rabatt code" };
    private final String[] optionsDropDown = { "Strecke", "Zeit" };
    private final String[] optionsDistance = { "Meter", "Kilometer" };
    private final String[] optionsTime     = { "Minuten", "Stunden" };
    private       String[] options         = optionsDistance;
    
    private final JPanel   panel           = new JPanel();
    
    private       JTextField TF_Amount     = new JTextField();
    private       JTextField TF_Discount   = new JTextField();
    
    private       JLabel T_Result          = new JLabel();
    private       JLabel T_Error           = new JLabel();
    private       JLabel T_Info            = new JLabel();
    private       JLabel T_Unit            = new JLabel();
    
    private JComboBox<String> D_Chose      = new JComboBox<>();
    private JComboBox<String> D_Optionen   = new JComboBox<String>();
    
    
    GUI(){
        mainframe.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainframe.setLayout(null);
        mainframe.setSize(windowSize[0]+15,windowSize[1]+40);
        mainframe.setVisible(true);
        mainframe.setTitle(title);
        mainframe.setBackground(Color.gray);
        CreatePanels();
        mainframe.repaint();
    }

    //erstellt ein JPanel und setzte alle Benötigen Objekte ein
    public final void CreatePanels(){
        final int rButtonPos = windowSize[0]-windowSize[0]/3-20;
        final int TextFieldWidth = windowSize[0]/3*1-80;
        final int hight = 20;
        final int xPosDropDown = windowSize[0]-290;
        
        //Panel einrichten
        panel.setBackground(Color.gray);
        panel.setBounds(0*(windowSize[0]), 0, windowSize[0], windowSize[1]);
        panel.setLayout(null);
        panel.setBorder(BorderFactory.createEtchedBorder(1));
        panel.setVisible(true);

        //Textfeld für die eingabe
        TF_Amount = addTextField(defaultFeldText[0], 20, 20, 20, TextFieldWidth);
        panel.add(TF_Amount);

        //Textfeld für den Rabattcode
        TF_Discount = addTextField(defaultFeldText[1], TextFieldWidth+70, 20, hight, TextFieldWidth);
        panel.add(TF_Discount);
        
        //Dropdown Menu (Strecke oder Zeit)
        D_Chose = addDropDown(optionsDropDown, xPosDropDown, 20, 0);
        panel.add(D_Chose);
        
        //Zeites Dropdown Menu ( m / km oder min / std )
        D_Optionen = addDropDown(options, xPosDropDown, 50, 1);
        panel.add(D_Optionen);

        //Knopf
        panel.add(addButton("Berechnen", rButtonPos, TextFieldWidth, 0));
        
        //Text ausgabe für das Ergebnis
        T_Result = addText("0,0 Euro", 20, 145, mode.result);
        panel.add(T_Result);
        
        //Text Ausgabe für einen Fehler
        T_Error = addText("", 20, 100, mode.error);
        panel.add(T_Error);

        //Hinweis Texte
        distance dist = new distance();
        time time = new time();
        final float Kilometer = dist.euroPerMeter*1000;
        final float hour = time.euroPerMinute*60;
        
        //Hinweis Text in HTML für die formatierung
        final String HinweisText = "<html><b><u>Preisliste:</u></b><br>1 Kilometer: " + Kilometer + "€ <br> 1 Stunde: " + hour + "€</html>" ;
        T_Info = addText(HinweisText, xPosDropDown, 90, mode.info);
        panel.add(T_Info);

        //Einheiten Text
        T_Unit = addText("m", 210, 0, mode.info);
        panel.add(T_Unit);
        
        //das eben konfiguriete panel zum Fenster hinzufügen
        mainframe.add(panel);
    }
    
    //wird ausgeführt, sobalt ein Dropdown menu geändert worden ist.
    @Override
    public void dropDownSelected(int id){
        //ändert das zweite dropdown Menu, falls das erste geöndert wird.
        if (id == 0){
            String selectedOption = (String) D_Chose.getSelectedItem();
            
            //wählt aus, welche Optionen im Zweite Dropdown Menu angezeigt werden
            switch (selectedOption){
                case "Strecke":
                    options = optionsDistance;
                    break;

                case "Zeit":
                    options = optionsTime;
                    break;
            }
            final int xPosDropDown = windowSize[0]-290;
            
            //erneuert alle DropDown Menus, damit bei veränderung von Strecke oder Zeit das Zweite Dropdown angepasst wird.
            refreshDropDown(addDropDown(options, xPosDropDown, 50, 1));
        }
        
        //ändert den einheiten Text, neben dem ersten Textfeld
        setEinheit();
    }

    //wird ausgeführt, sobalt ein Button gedrückt wird,
    @Override
    public void buttonPressed(int id){
        int[] EuroCent = new int[2];
        //Ausgewählter inhalt des ersten Dropdown Menus (Strecke / Zeit)
        String selectedOption = (String) D_Chose.getSelectedItem();
        
        //Ausgewählter inhalt des zweoten Dropdown Menus (einheit)
        String selectedSecondOption = (String) D_Optionen.getSelectedItem();
        
        //Inhalt des Ersten eingabe Feldes (eingabe)
        String amount = (String) TF_Amount.getText();
        
        //Inhalt des zweiten Eingabe Feldes (Rabattcode)
        String discountCode = (String) TF_Discount.getText();
        
        String ShowDiscount = "";
        
        //wählt aus, ob Strecke oder Zeit des ersten DropDown Menues
        switch (selectedOption){
            case "Strecke":
                distance dist = new distance();
                //wählt Meter oder Kilometer des zweiten DropDown Menus
                switch (selectedSecondOption){
                    case "Meter":
                        dist.setMeter(amount);
                        break;

                    case "Kilometer":
                        dist.setKilometer(amount);
                        break;
                }
                //Wendet den Rabattcode aus dem Zweiten Textfeld an
                //Setzt den Text (Fehler oder erfolgsmeldung)
                //Setzt die Farbe jenachdem ob Fehler oder Erfolgreich
                if (!(dist.ApplyRabattCode(discountCode))){
                    ShowDiscount = "Ungültiger Code";
                    T_Error.setForeground(Color.RED);
                } else {
                    ShowDiscount = "Code " + discountCode + " wurde erfolgreich angewendet.";
                    T_Error.setForeground(Color.BLACK);
                }
                EuroCent = dist.calculate();
                break;

                
            case "Zeit":
                time time = new time();
                //wählt Minuten oder Stunden des zweiten DropDown Menus
                switch (selectedSecondOption){
                    case "Minuten":
                        time.setMinuten(amount);
                        break;
                        
                    case "Stunden":
                        time.setStunden(amount);
                        break;
                }
                
                //Wendet den Rabattcode aus dem Zweiten Textfeld an
                //Setzt den Text (Fehler oder erfolgsmeldung)
                //Setzt die Farbe jenachdem ob Fehler oder Erfolgreich
                if (!(time.ApplyRabattCode(discountCode))){
                    ShowDiscount = "Ungültiger Rabatt Code!";
                    T_Error.setForeground(Color.RED);
                } else {
                    ShowDiscount = "Code: " + discountCode + " wurde erfolgreich angewendet.";
                    T_Error.setForeground(Color.BLACK);
                }
                EuroCent = time.calculate();
                break;


        }
        
        //Setzt den Text der Rabatt Anzeige bzw. der Fehlermeldung
        T_Error.setText(ShowDiscount);
        
        //Setzt den Text des ausgerechneten Euro wertes
        String Euro = EuroCent[0] + "," + EuroCent[1] + " Euro";
        T_Result.setText(Euro);
        
        //aktualliert alle Texte und Zeigt diese an.
        refreshText();
    }
    
    //aktualliesert alle Texte
    private void refreshText(){
        
        //geht durch alle objekte im Panel durch und löscht alle JLabels (Texte)
        Component[] components = panel.getComponents();
        for (Component component : components) {
            if (component instanceof JLabel) {
                panel.remove(component);
            }
        }
        
        //Fügt die (akktualiserten) Texte wieder ein
        panel.add(T_Result);
        panel.add(T_Error);
        panel.add(T_Info);
        panel.add(T_Unit);
        
        //erneuert das Panel, so das die änderungen angezeigt werden
        panel.revalidate();
        panel.repaint();
    }
    
    //aktuallisert alle DropDown Menues
    private void refreshDropDown(JComboBox<String> DropDown){
        
        //geht durch alle Objekte durch und Löscht alle DropDown Menues
        Component[] components = panel.getComponents();
        for (Component component : components) {
            if (component instanceof JComboBox ) {
                panel.remove(component);
            }
        }
        
        //Setzt das Zweite Dropdown Menu, durch dass welches der Methode übergeben wurde
        D_Optionen = DropDown;
        
        //Fügt die Dropdown Menus wieder hinzu.
        panel.add(D_Chose);
        panel.add(D_Optionen);
        
        //erneuert das Panel, so das die änderungen angezeigt werden
        panel.revalidate();
        panel.repaint();
    }
    
    //Erneuert den Einheuten Text, neben dem Eingabe TextFeld.
    private void setEinheit(){
        
        //setzt den Text, jemand was im Zweiten DropDown steht
        switch((String) D_Optionen.getSelectedItem()){
            case "Minuten":
                T_Unit.setText("min");
                break;
            case "Stunden":
                T_Unit.setText("std");
                break;
            case "Meter":
                T_Unit.setText("m");
                break;
            case "Kilometer":
                T_Unit.setText("km");
                break;
            default:
                T_Unit.setText("??");
        }
        
        //erneuert den Text
        refreshText();
    }
    
}