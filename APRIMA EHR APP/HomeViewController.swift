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
    
    @IBOutlet var sync_button: UIButton!
    
    @IBAction func syncButtonTapped(){
        // Get the patient ID and JsonWebToken from NSUserdefaults
        let patient_id = self.defaults.objectForKey("patient_id") as! String
        let json_web_token = self.defaults.objectForKey("json_web_token") as! String
        
        // URL to send POST request to
        let url: NSURL = NSURL(string: "https://aprod-sbt2.servicebus.windows.net/7083c80b-29e2-4ee8-a485-3a3fdf373f58/api/v1/patients/\(patient_id)/attachmentscsv")!
        
        print("Patient ID: \(patient_id)")
        print("Json Web Token: \(json_web_token)")
        print("url: \(url)")
        
        // Make sure to set up post body, which will be the data (formatted) to send
        // TO DO - Set up post body here
        // let post_data = ...
        
        // create a session for the POST request
        let session = NSURLSession.sharedSession()
        
        // Create the POST request
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
//        request.HTTPBody = post_data
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("C83BBF42-DA17-4F58-9AA0-68F417419313", forHTTPHeaderField: "ApiKey")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(json_web_token)", forHTTPHeaderField: "Auth-Token")
    }

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
