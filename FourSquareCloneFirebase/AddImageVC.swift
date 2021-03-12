//
//  AddImageVC.swift
//  FourSquareCloneFirebase
//
//  Created by Muhammet Midilli on 8.03.2021.
//

import UIKit
import Firebase

class AddImageVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageViewAdd: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmosphereText: UITextField!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //before select image
        nextButtonOutlet.isEnabled = false
        
        //enable to tap imageview
        imageViewAdd.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageViewAdd.addGestureRecognizer(gestureRecognizer)
        
        //hiding keyboard when tap vc except for keyboard
        let hidingGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hidingGestureRecognizer)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        //alerts
        if nameText.text == "" {
            self.makeAlert(messageInput: "Name field cannot be empty!")
        } else if placeTypeText.text == "" {
            self.makeAlert(messageInput: "Place type cannot be empty!")
        } else if placeAtmosphereText.text == "" {
            self.makeAlert(messageInput: "Place atmosphere cannot be empty!")
        }
        //to toaddmapvc segue
        self.performSegue(withIdentifier: "toaddmapvc", sender: nil)
    }
    
    //alert func to use many times
    func makeAlert(messageInput : String) {
        let alert = UIAlertController(title: "Error!", message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    //select image func
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    //after select image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewAdd.image = info[.originalImage] as? UIImage
        //close picker
        self.dismiss(animated: true, completion: nil)
        //make button touchable after choose phote
        self.nextButtonOutlet.isEnabled = true
    }
    
    //call the AddMapVC variables
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toaddmapvc" {
            let destinationController = segue.destination as! AddMapVC
            destinationController.name = nameText.text!
            destinationController.placeType = placeTypeText.text!
            destinationController.placeAtmosphere = placeAtmosphereText.text!
            destinationController.photo = imageViewAdd.image!
        }
    }
    
    //hiding keyboard objc fun
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
