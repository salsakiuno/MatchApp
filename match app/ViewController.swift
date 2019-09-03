//
//  ViewController.swift
//  match app
//
//  Created by Vannia Alfaro alfaro on 23/04/2019.
//  Copyright © 2019 Vannia Alfaro alfaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstCardIsFlippedIndex: IndexPath?
    
    var timer:Timer?
    var miliseconds:Float = 10 * 1000 // 10 seconds
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the getCards method of the card model
        cardArray = model.getCards()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        //create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapse), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    //MARK: - Timer Methods
    
    @objc func timerElapse(){
        miliseconds -= 1
        
        //convert to seconds
        let seconds = String(format: "%.2f", miliseconds/1000)
        
        //set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //When timer reach 0 we want to stop it
        
        if miliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //check if there are any card unmatched
            
            checkGameEnded()
        }
        
    }

    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        // Get a cardCollectionView Object
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)  as! CardCollectionViewCell
        
        //get that card the collectionView is trying to display
        let card = cardArray[indexPath.row]
        
        //set the card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Check if there is any time left
        
        if miliseconds <= 0{
            return
        }
        
        //get the cell the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get the card the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            // flip the card
            cell.flip()
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
//         Determine if it's the first card or the second card that's flipped over
            if firstCardIsFlippedIndex == nil {
                // this means it's the first card flipped
                firstCardIsFlippedIndex = indexPath
            }else {
//                this is the second card flipped
                checkForMatched(indexPath)
            }

    	}
    }   
    
    // MARK: - matching methods logic
    
    func checkForMatched(_ secondFlippedCardIndex: IndexPath){
        // get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at:
            firstCardIsFlippedIndex!)as? CardCollectionViewCell
        
        let cardTwoCell =  collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // get the cards for the two cards that were revealed
        
        let cardOne = cardArray[firstCardIsFlippedIndex!.row]
        let cardTwo =  cardArray[secondFlippedCardIndex.row]
        
        //Compare the two cards
        
        if cardOne.imageName == cardTwo.imageName{
            
            //play sound when it's a match
            SoundManager.playSound(.match)
            
            //it's a match
            //set the status of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //remove those cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // check if there are any cards left unmatched
            
        checkGameEnded()
            
        
        }else{
            //play sound when is not a match
            SoundManager.playSound(.unmatch)
            
            //It's not a match
            //set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //tell the collection view to reload for the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstCardIsFlippedIndex!])
        }
        
        //refresh the property that refresh the first card flipped
        firstCardIsFlippedIndex = nil
        
    }
    
    func checkGameEnded(){
        //Determine if there are any cards unmatched
        var isWon = true
        for card in cardArray{
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        //Messaging variables
        var title = ""
        var message = ""
        
        //if not, then user has won the timer
        if isWon == true{
            
            if miliseconds > 0 {
                timer?.invalidate()
                
            }
            title = "Congratulations"
            message = "You've won"
            
        }else{
             //if there are unmatcheed cards, check if there is any time left
            if miliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
            
        }
        
        //show won/lost messaging
        showAlert(title, message)
    }
    
    func reset() {
        //TODO: RESET TIMER AND RESTART, SET CARDS, SCROLL TO TOP
        
    }
    
    func showAlert(_ title:String, _ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let resetAction = UIAlertAction(title: "Try again", style: .default, handler: nil)

        
        alert.addAction(alertAction)
        alert.addAction(resetAction)
        
        present(alert, animated: true, completion: nil)
    
    }
}// end of the view controller


