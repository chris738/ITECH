/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newpackage;

public class distance extends cost {
    public final float euroPerMeter = 0.2f;
    private float meter;
    
    //Setzt den Meter wert
    public void setMeter(String input){
        meter = Float.parseFloat(input);
    }
    
    //setzt den Meter wert, Kilometer werden in Meter umgerechnet
    public void setKilometer(String input){
        meter = Float.parseFloat(input) * 1000;   
    }
    
    //Berechnet den Eurowert 
    //(Rabattcode wird angewendet, falls dieser zuvor gesetzt worden ist)
    public int[] calculate(){
        setEuro(meter * euroPerMeter);
        return getEuroCent();
    }
}
