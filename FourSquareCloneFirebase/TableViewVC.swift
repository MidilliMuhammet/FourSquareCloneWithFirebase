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
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegation
        tableView.delegate = self
        tableView.dataSource = self
        
        //add + button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
                
        //logoutbutton
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        
        getData()
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
        fireStoreDatabase.collection("Places").order(by: "Places", descending: true).addSnapshotListener { (snapshot, error) in
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
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        
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
}
