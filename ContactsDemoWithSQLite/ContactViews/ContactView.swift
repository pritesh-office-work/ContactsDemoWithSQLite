//
//  ContactView.swift
//  ContactsDemoWithSQLite
//
//  Created by Pritesh Patel on 15/04/23.
//

import UIKit

class ContactView: UIViewController {

    @IBOutlet weak var txtName, txtPhone, txtEmail: UITextField?
    @IBOutlet weak var imgProfilePhoto: UIImageView?
    @IBOutlet weak var btnProfilePhoto, btnSave: UIButton?
    
    private var contactViewModel = ContactViewModel()

    var contactModel: ContactModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\((contactModel == nil) ? "Add" : "Update") Contact"
        
        contactViewModel.contact = contactModel
        
        if contactViewModel.contact != nil {
            txtName?.text = contactViewModel.contact?.name
            txtPhone?.text = contactViewModel.contact?.phone
            txtEmail?.text = contactViewModel.contact?.email
            imgProfilePhoto?.maskCircle(anyImage: UIImage(data: contactViewModel.contact!.profilePhoto))
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnProfilePhotoClicked(_ sender: Any) {
        openImagePicker()
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        validateAndSaveContactInDB()
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

extension ContactView {
    
    func validateAndSaveContactInDB() {
        
        guard let name = txtName?.text, name != "" else {
            showAlert(with: "Please enter name", title: "Error Alert")
            return
        }
        guard let phone = txtPhone?.text, phone != "" else {
            showAlert(with: "Please enter phone number", title: "Error Alert")
            return
        }
        guard let email = txtEmail?.text, email != "" else {
            showAlert(with: "Please enter email", title: "Error Alert")
            return
        }
        guard email.isValidEmail else {
            showAlert(with: "Please enter valid email", title: "Error Alert")
            return
        }
        
        if contactModel == nil {
            if let id = DatabaseManager.shared.addContact(cname: name, cphone: phone, cemail: email, cprofilePhoto: (imgProfilePhoto?.image?.jpegData(compressionQuality: 1.0))!) {
                print("id: \(id)")
                contactViewModel.contact = ContactModel(id: id, name: name, phone: phone, email: email, profilePhoto: (imgProfilePhoto?.image?.jpegData(compressionQuality: 1.0))!)
            }
        } else {
            contactViewModel.contact?.update(name: name, phone: phone, email: email, profilePhoto: (imgProfilePhoto?.image?.jpegData(compressionQuality: 1.0))!)
            if let contact = contactViewModel.contact {
                let status = DatabaseManager.shared.updateContact(cid: contact.id!, newContact: contact)
                print("status: \(status)")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension ContactView: ImagePickerPresentable {
    
    func openImagePicker() {
        showImagePicker(allowsEditing: true, source: [.camera, .photoLibrary])
    }
    
    func selectedImage(image: UIImage?) {
        
        self.imgProfilePhoto?.maskCircle(anyImage: image?.compressTo(100))
        
    }
}

extension ContactView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > textField.text!.count {
            return false
        }
        
        let newLength = textField.text!.count + string.count - range.length

        if textField == txtName || textField == txtEmail {
            return (newLength > 100) ? false : true
        }
        
        if textField == txtPhone {
            if newLength == 10 && textField.returnKeyType == UIReturnKeyType.default {
                textField.returnKeyType = UIReturnKeyType.go
                textField.reloadInputViews()
            } else if textField.returnKeyType == UIReturnKeyType.go && newLength < 10 {
                textField.returnKeyType = UIReturnKeyType.default
                textField.reloadInputViews()
            }
            let characterSet = CharacterSet(charactersIn: "1234567890").inverted
            let filtered = string.components(separatedBy: characterSet).joined(separator: "")
            if string == filtered {
                return (newLength > 10) ? false : true
            } else {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtName {
            txtPhone?.becomeFirstResponder()
        } else if textField == txtPhone {
            txtEmail?.becomeFirstResponder()
        } else if textField == txtEmail {
            validateAndSaveContactInDB()
        }
        return true
    }
}
