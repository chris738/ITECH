/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newpackage;

import java.util.Scanner;

public class Cmd {
    private String discountCode = "";
    private int[] Output = new int[2];
    
    public void Menu(){
        System.out.println("     Menu:");
        System.out.println(" [s] Kosten nach Strecke ");
        System.out.println(" [z] Kosten nach Zeit ");
        System.out.println(" [r] Rabatt Code Eingaben ");
        System.out.println(" [x] Beenden");
        switch(getInput()) {
            case "S":
            case "s":
                distance();
                break;
                
            case "Z":
            case "z":
                time();
                break;
                
            case "R":
            case "r":
                discountCode = getInput();
                break;
            case "X":
            case "x":
                break;
                
            default:
                System.out.println("Falsche Eingabe!");
                break;
            
        }
        System.out.println(" " + Output[0] + "," + Output[1] + " Euro");
    }
    
    private static String getInput(){
        String input;
        System.out.println("     Auswahl: ");
        Scanner scan = new Scanner(System.in); //holt die Konsoleneingabe
        input = scan.nextLine(); //schiebt die Konsoleneingabe in den input variable
        return input;
    }
    
    private void distance(){
        distance dist = new distance();
        dist.ApplyRabattCode(discountCode);
        
        System.out.println("     Strecke:");
        System.out.println(" [m] Metern");
        System.out.println(" [k] Kilometer");
        switch(getInput()) {
            case "m":
            case "M":
                dist.setMeter(getInput());
                break;
                        
            case "k":
            case "K":
                dist.setKilometer(getInput());
                break;
                        
            default:
                System.out.println("Falsche Eingabe!");
                break;
        }
        dist.ApplyRabattCode(discountCode);
        Output = dist.calculate();
    }
    
    private void time(){
        time time = new time();
        time.ApplyRabattCode(discountCode);
        
        System.out.println("     Zeit:");
        System.out.println(" [s] Stunden");
        System.out.println(" [m] Minuten");
        switch(getInput()) {
            case "s":
                time.setStunden(getInput());
                Output = time.calculate();
                break;
                
            case "m":
                time.setMinuten(getInput());
                Output = time.calculate();
                break;
                
            default:
                System.out.println("Falsche Eingabe!");
                break;
        }
    }
}
