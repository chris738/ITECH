/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newpackage;

public class time extends cost {
    public final float euroPerMinute = 0.44f;
    private int minutes;
    
    //stezt den Minuten wert, Stunden werden in Minuten umgewandelt
    public void setStunden (String input){
        minutes = (int) Math.round(Float.parseFloat(input) * 60);
    }
    
    //setzt den Minuten wert
    public void setMinuten(String input){
        minutes = Integer.parseInt(input);
    }
    
    //Berechnet den Eurowert 
    //(Rabattcode wird angewendet, falls dieser zuvor gesetzt worden ist)
    public int[] calculate(){
        setEuro(minutes * euroPerMinute);
        return getEuroCent();
    }
}
