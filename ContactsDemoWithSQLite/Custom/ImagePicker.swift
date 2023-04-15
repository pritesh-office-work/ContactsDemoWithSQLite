//
//  ImagePicker.swift
//  ContactsDemoWithSQLite
//
//  Created by Pritesh Patel on 15/04/23.
//

import UIKit
import Foundation

protocol ImagePickerPresentable: AnyObject {
    func showImagePicker(allowsEditing:Bool, source: [UIImagePickerController.SourceType])
    func selectedImage(image: UIImage?)
}

fileprivate class ImagePicker: NSObject {
    
    weak var delegate: ImagePickerPresentable?
    
    fileprivate struct `Static` {
        fileprivate static var instance: ImagePicker?
    }
    
    fileprivate class var shared: ImagePicker {
        if ImagePicker.Static.instance == nil {
            ImagePicker.Static.instance = ImagePicker()
        }
        return ImagePicker.Static.instance!
    }
    
    fileprivate func dispose() {
        ImagePicker.Static.instance = nil
    }
    
    func picker(picker: UIImagePickerController, selectedImage image: UIImage?) {
        picker.dismiss(animated: true, completion: nil)
        self.delegate?.selectedImage(image: image)
        self.delegate = nil
        self.dispose()
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker(picker: picker, selectedImage: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard var image = info[.originalImage] as? UIImage else {
            return self.picker(picker: picker, selectedImage: nil)
        }
        
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        }
        
        self.picker(picker: picker, selectedImage: image)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.picker(picker: picker, selectedImage: image)
    }
}

extension ImagePickerPresentable where Self: UIViewController {
    
    fileprivate func pickerControllerActionFor(for type: UIImagePickerController.SourceType, title: String, allowsEditing:Bool) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            let pickerController           = UIImagePickerController()
            pickerController.delegate      = ImagePicker.shared
            pickerController.sourceType    = type
            pickerController.allowsEditing = allowsEditing
            self.present(pickerController, animated: true)
        }
    }
    
    func showImagePicker(allowsEditing:Bool, source: [UIImagePickerController.SourceType]) {
        ImagePicker.shared.delegate = self
        
        let optionMenu = UIAlertController(title: "Select", message: nil, preferredStyle: .alert)
        
        if source.count == 1 {
            
            if !UIImagePickerController.isSourceTypeAvailable(source.first!) {
                //self.showAlertMessage("Camera not available in your decive")
                return
            }
            
            let pickerController           = UIImagePickerController()
            pickerController.delegate      = ImagePicker.shared
            pickerController.sourceType    = source.first!
            pickerController.allowsEditing = allowsEditing
            self.present(pickerController, animated: true)
            return
        }
        
        if source.contains(.camera) {
            if let action = self.pickerControllerActionFor(for: .camera, title: "Camera", allowsEditing: allowsEditing) {
                optionMenu.addAction(action)
            }
        }
        
        if source.contains(.photoLibrary) {
            if let action = self.pickerControllerActionFor(for: .photoLibrary, title: "Photo Library", allowsEditing: allowsEditing) {
                optionMenu.addAction(action)
            }
        }
        
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(optionMenu, animated: true)
    }
}
