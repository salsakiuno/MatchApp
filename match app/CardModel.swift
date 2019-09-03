//
//  CardModel.swift
//  match app
//
//  Created by Vannia Alfaro alfaro on 25/04/2019.
//  Copyright © 2019 Vannia Alfaro alfaro. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card] {
    
        // Declare an array to store the generated cards
        var genetatedCardsArray = [Card]()
    
        // Randomly generate pairs of cards
        for _ in 1...8{
        
            // get a random number
            let randomNumber = arc4random_uniform(13)+1
            
            //log the number
            print("generating a random nunber \(randomNumber)")
            
            let cardOne = Card()
            //first Card object
            cardOne.imageName = "card\(randomNumber)"
            
            genetatedCardsArray.append(cardOne)
            
            //second Card object
            let cardTwo = Card()
            
            cardTwo.imageName = "card\(randomNumber)"
            
            genetatedCardsArray.append(cardTwo)
            
            //OPTIONAL: Make it so we only have unique pairs of cards
        }
        
        // TODO: Randomize the array
        print("card totals: \(genetatedCardsArray.count)")
        // return the array
        return genetatedCardsArray
    }
}
