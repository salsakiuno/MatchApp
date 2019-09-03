//
//  CardCollectionViewCell.swift
//  match app
//
//  Created by Vannia Alfaro alfaro on 25/04/2019.
//  Copyright © 2019 Vannia Alfaro alfaro. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fronImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard (_ card:Card){
        
        self.card = card
        
        fronImageView.image = UIImage(named: card.imageName)
        
        //if the card has been matched, then make the image view invisble
        if card.isMatched == true {
            backImageView.alpha = 0
            fronImageView.alpha = 0
            
            return
            
        }else{
            
            // if the card hasn't matched, then make the image view visible
            backImageView.alpha = 1
            fronImageView.alpha = 1
        }
        
//        determinted if the card is in a flipped up and flipped down
        if card.isFlipped == true{
            // make sure the frontImageView is on the top
                UIView.transition(from: backImageView, to: fronImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        }else {
            //make sure the backImageView is on the top
            UIView.transition(from: fronImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func flip(){
        
        UIView.transition(from: backImageView, to: fronImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.fronImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove(){
        
        //Remove both images view from being visible
                backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.fronImageView.alpha = 0
        }, completion: nil)
        
    }
    
}
