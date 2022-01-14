//
//  ViewController.swift
//  Detector
//
//  Created by 송원선 on 2022/01/14.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imgView: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnGallery(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            flagImageSave = false
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [UTType.image.identifier]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            myAlert(_title: "gallery x", message: "갤러리에 접근할 수 없습니다.")
        }
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            flagImageSave = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [UTType.image.identifier]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            myAlert(_title: "camera x", message: "카메라에 접근할 수 없습니다.")
        }
    }
    
    
    func myAlert(_title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: UTType.image.identifier){
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            
            if flagImageSave{
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
            imgView.image = captureImage
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

