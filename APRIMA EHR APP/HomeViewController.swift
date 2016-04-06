//
//  FirstViewController.swift
//  APRIMA EHR APP
//
//  Created by david on 2/17/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Used to store the user's data
    let defaults = NSUserDefaults.standardUserDefaults()
    let is_health_kit_enabled = NSUserDefaults.standardUserDefaults().boolForKey("is_health_kit_enabled")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(animated: Bool){
        // Automatically switch to login scene if user is not logged in
        if(!defaults.boolForKey("is_user_logged_in")){
            self.performSegueWithIdentifier("login_view_segue", sender: self)
        }

    }
}

//import AVFoundation
//
////code to play music
//class MusicHelper {
//    static let sharedHelper = MusicHelper()
//    var audioPlayer: AVAudioPlayer?
//    
//    func playBackgroundMusic() {
//        let aSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("way-to-success", ofType: "mp3")!)
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOfURL:aSound)
//            audioPlayer!.numberOfLoops = -1
//            audioPlayer!.prepareToPlay()
//            audioPlayer!.play()
//        } catch {
//            print("Cannot play the file")
//        }
//    }
//}
