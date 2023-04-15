//
//  ContactListView.swift
//  ContactsDemoWithSQLite
//
//  Created by Pritesh Patel on 15/04/23.
//

import UIKit

class ContactListView: UIViewController {
    
    @IBOutlet weak var tblViewContacts: UITableView?
    
    private var contactListViewModel = ContactListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Contacts"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contactListViewModel.getContacts()
        
        self.tblViewContacts?.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListViewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        cell.showContactDetails(contact: contactListViewModel.contacts[indexPath.row])
        return cell
    }
}
