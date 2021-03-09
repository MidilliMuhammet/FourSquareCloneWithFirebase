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
    var userEmailArray = [String]()
    var placeArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegation
        tableView.delegate = self
        tableView.dataSource = self
        
        //add + button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    
    //require for tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //require for tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test"
        return cell
    }
    
    //for add button
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toaddimagevc", sender: nil)
    }
    
    //get data func
    func getData() {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Places").order(by: "Places", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.placeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        
                    }
                }
            }
        }
    }


   
    
    
    

}
