//
//  SoundManager.swift
//  match app
//
//  Created by Vannia Alfaro alfaro on 12/06/2019.
//  Copyright © 2019 Vannia Alfaro alfaro. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffct {
        case flip
        case shuffle
        case match
        case unmatch
    }
    
    static func playSound(_ effect: SoundEffct){
        
        var soundFilename = ""
        
        // Determin which sound effect we want to play
        // and set the appropiate file name
        switch effect {
            
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .unmatch:
            soundFilename = "dingwrong"
        }
        
        // Get the path of sound file in the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else {
            print("We couldn't find your sound file \(soundFilename) in the Bundle")
            return
        }
        
        //  Create url object from this string path
        let soundUrl = URL(fileURLWithPath: bundlePath!)
        
        // Create audio player object
        do {
            
        audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            
        // play the sound
        audioPlayer?.play()
            
        }
        catch {
            //couldn't create audio player object for the sound file
            print("Couldn't create the audio player object for the \(soundFilename)")
        }
    
    }

    
}
