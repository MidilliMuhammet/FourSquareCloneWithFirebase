//
//  TableViewVC.swift
//  FourSquareCloneFirebase
//
//  Created by Muhammet Midilli on 8.03.2021.
//

import UIKit
import Firebase

class TableViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //variables
    var userPlaceNameArray = [String]()
    var userPlaceTypeArray = [String]()
    var userPlaceAtmosphereArray = [String]()
    var userImageArray = [String]()
    var userLatitudeArray = [Double]()
    var userLongitudeArray = [Double]()
    var chosenName = ""
    var chosenPlaceType = ""
    var chosenPlaceAtmosphere = ""
    var chosenImage = ""
    var chosenLatitude = 0.00
    var chosenLongitude = 0.00
    var documentIDArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        //delegation
        tableView.delegate = self
        tableView.dataSource = self
        
        //add + button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
                
        //logoutbutton
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
    }
    
    //require for tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPlaceNameArray.count
    }
    
    //require for tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userPlaceNameArray[indexPath.row]
        return cell
    }
    
    //for + button
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toaddimagevc", sender: nil)
    }
    
    //for logout
    @objc func logoutButtonClicked() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toSignIn", sender: nil)
        } catch {
            print("Error!")
        }
    }
    
    //get data func
    func getData() {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Places").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    //before updating remove old datas
                    self.userPlaceNameArray.removeAll(keepingCapacity: false)
                    self.userPlaceTypeArray.removeAll(keepingCapacity: false)
                    self.userPlaceAtmosphereArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userLatitudeArray.removeAll(keepingCapacity: false)
                    self.userLongitudeArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.documentIDArray.append(documentId)
                        if let placename = document.get("placename") as? String {
                            self.userPlaceNameArray.append(placename)
                        }
                        if let placetype = document.get("placetype") as? String {
                            self.userPlaceTypeArray.append(placetype)
                        }
                        if let placeatmosphere = document.get("placeatmosphere") as? String {
                            self.userPlaceAtmosphereArray.append(placeatmosphere)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        if let latitude = document.get("latitude") as? Double {
                            self.userLatitudeArray.append(latitude)
                        }
                        if let longitude = document.get("longitude") as? Double {
                            self.userLongitudeArray.append(longitude)
                        }
                    }
                    //reload after adding new datas
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //search "didselectrow", when selected a row, get the index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenName = userPlaceNameArray[indexPath.row]
        chosenPlaceType = userPlaceTypeArray[indexPath.row]
        chosenPlaceAtmosphere = userPlaceAtmosphereArray[indexPath.row]
        chosenImage = userImageArray[indexPath.row]
        chosenLatitude = userLatitudeArray[indexPath.row]
        chosenLongitude = userLongitudeArray[indexPath.row]
        performSegue(withIdentifier: "todetailsvc", sender: nil)
    }
    
    //show the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todetailsvc" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenName = chosenName
            destinationVC.chosenPlaceType = chosenPlaceType
            destinationVC.chosenPlaceAtmosphere = chosenPlaceAtmosphere
            destinationVC.chosenImage = chosenImage
            destinationVC.chosenLatitude = chosenLatitude
            destinationVC.chosenLongitude = chosenLongitude
        }
    }
}
