/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newpackage;

public class cost {
    //EuroCent[0] = Euro als int
    //EuroCent[1] = Celt als int.
    private final int[] EuroCent = new int[2];
    private float discount = 1;

    //Setzt den Rabatt je nach Rabbatcode
    public boolean ApplyRabattCode(String discountCode){
            //Tec5 für 5%, 
            //Tec15 für 15%, 
            //TecFirstTry für 50%
            switch (discountCode){
                case "Tec5":
                    discount = 0.95f;
                    break;

                case "Tec15":
                    discount = 0.85f;
                    break;

                case "TecFirstTry":
                    discount = 0.50f;
                    break;

                default:
                    discount = 1;
                    return false;
            } 
            return true;
        }
    
    //Setzt den Euro Wert und wendet den rabattcode, falls einer hinterlegt ist.
    //Automatisch an.
    //Geseichert wird er Euro wert in zwei Integerwerten.
    public void setEuro(float inputEuro){
        
        //wendet den Discount an, sollte dieser angegeben worden sein.
        inputEuro = inputEuro * discount;
        
        //durch das casten zu einem integer werden die dezimalstellen entfert. also aus bsp. 1.87 wird 1
        EuroCent[0] = (int) inputEuro;
        
        //durch das abziehen des soeben gecasteten euro wert (EuroCent[0]) , bleibt nur die dezimalszelle stehen also aus 1.87 wird 0.87. 
        // Dannach wird x100 genommen, so dass dann 87 als integer (cent) gespeichert werden kann.
        // es wird nochmal nach int gecasted, falls fragmente im cent betrag stehen.
        EuroCent[1] = (int) Math.round((inputEuro - EuroCent[0]) * 100); 
    }
    
    //Gibt das EuroCent Array zurück
    public int[] getEuroCent(){
        return EuroCent;
    }
}