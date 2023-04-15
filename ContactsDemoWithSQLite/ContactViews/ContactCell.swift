//
//  ContactCell.swift
//  ContactsDemoWithSQLite
//
//  Created by Pritesh Patel on 15/04/23.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblPhone: UILabel?
    @IBOutlet weak var lblEmail: UILabel?
    @IBOutlet weak var imgProfilePhoto: UIImageView?
    
    @IBOutlet weak var btnUpdate: UIButton?
    @IBOutlet weak var btnDelete: UIButton?

    private var contact: ContactModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showContactDetails(contact: ContactModel) {
        self.contact = contact
        
        lblName?.text = contact.name
        lblPhone?.text = contact.phone
        lblEmail?.text = contact.email
        imgProfilePhoto?.maskCircle(anyImage: UIImage(data: contact.profilePhoto))
    }
    
    @IBAction func btnUpdateClicked(_ sender: Any) {
        
        if let contactListView = parentViewController as? ContactListView {
            let contactView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactView") as! ContactView
            contactView.contactModel = contact
            contactListView.navigationController?.pushViewController(contactView, animated: true)
        }
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        
        deleteContact(contact: contact!)
    }
}


extension ContactCell {
    func deleteContact(contact: ContactModel) {
        
        if let contactListView = parentViewController as? ContactListView {
            let confirmAlert = UIAlertController(title: "", message: "Are you sure you want to delete this contact ? ", preferredStyle: .alert)
            confirmAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in

                let status = DatabaseManager.shared.deleteContact(cid: contact.id!)
                print("status: \(status)")
                if status {
                    contactListView.viewWillAppear(true)
                }
            }))

            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

                confirmAlert.dismiss(animated: true, completion: nil)
            }))

            contactListView.present(confirmAlert, animated: true, completion: nil)
        }
    }
}
