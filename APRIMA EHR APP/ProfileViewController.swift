//
//  ProfileViewController.swift
//  APRIMA EHR APP
//
//  Created by henry dinh on 2/23/16.
//  Copyright © 2016 david nguyen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // initialize a HealthKit object to pull data from
    let health_kit: HealthKit = HealthKit()
    
    // View objects
    @IBOutlet var table_view: UITableView!
    @IBOutlet var profile_image_view: UIImageView!
    @IBOutlet var profile_image_button: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    // Lets the user update the profile image when the button is pressed.
    // The button is pu on top of the image so that the user can just press the image to do this.
    @IBAction func updateProfileImage(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Refreshes the UI
    func refreshUI(){
        // Make sure the user authorized health kit before attempting to pull data
        if Authorized.enabled == true{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set profile image radius to half the width of UIImageView to make it circular
        profile_image_view.layer.cornerRadius = profile_image_view.frame.size.width / 2
        profile_image_view.clipsToBounds = true
        // Add a border to the image
        profile_image_view.layer.borderWidth = 3.0
        profile_image_view.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    // Called everytime the UI is displayed (i.e. the user goes to the profile tab)
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        profile_image_view.image = image
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
