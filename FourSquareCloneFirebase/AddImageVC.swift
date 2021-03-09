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
        //upload
        else {
            let storage = Storage.storage()
            let storageReference = storage.reference()
            //choosing folder if it is not existing it will create automaticilly
            let mediaFolder = storageReference.child("photo")
            //convert image to data, 0.5 is compression rate
            if let data = imageViewAdd.image?.jpegData(compressionQuality: 0.5) {
                //creating image name and uuid
                let uuid = UUID().uuidString
                //save as jpeg
                let imageReference = mediaFolder.child("\(uuid).jpeg")
                imageReference.putData(data, metadata: nil) { (metadeta, error) in
                    if error != nil {
                        self.makeAlert(messageInput: error?.localizedDescription ?? "Error!")
                    } else {
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                //convert url to string
                                let imageUrl = url?.absoluteString
                                //database
                                let firestoreDatabase = Firestore.firestore()
                                var firestoreReference : DocumentReference? = nil
                                let firestorePost = ["imageUrl" : imageUrl!, "name" : self.nameText.text!, "placetype" : self.placeTypeText.text!, "placeatmosphere" : self.placeAtmosphereText.text! ] as! [String : Any]
                                firestoreReference = firestoreDatabase.collection("Places").addDocument(data: firestorePost, completion: { (error) in
                                    if error != nil {
                                        self.makeAlert(messageInput: error?.localizedDescription ?? "Error!")
                                    } else {
                                        //if no error goes to addmapvc
                                        self.performSegue(withIdentifier: "toaddmapvc", sender: nil)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
            
            
        }
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
    

}
