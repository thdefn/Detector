//
//  ViewController.swift
//  Detector
//
//  Created by 송원선 on 2022/01/14.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation
import Foundation
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCapturePhotoCaptureDelegate {

    @IBOutlet var imgView: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var beginImage: CIImage!
    var flagImageSave = false
    var isAutoCaptureEnabled = false
    private let photoCaptureOutput = AVCapturePhotoOutput()
    var context = CIContext(options: nil)
    
    
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
            
            //imgView.image = captureImage
           makeRectangle()
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeRectangle() {
        beginImage = CIImage(image: captureImage!)!
        var rect: CIRectangleFeature = CIRectangleFeature()
        
        if let detector = CIDetector(ofType: CIDetectorTypeRectangle, context: context, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh]){
            rect = detector.features(in: beginImage).first as! CIRectangleFeature
        }
        
        let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection")!
        beginImage = CIImage(image: captureImage!)!
        
        perspectiveCorrection.setValue(CIVector(cgPoint: rect.topLeft), forKey: "inputTopLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: rect.topRight), forKey: "inputTopRight")
        perspectiveCorrection.setValue(CIVector(cgPoint: rect.bottomLeft), forKey: "inputBottomLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: rect.bottomRight), forKey: "inputBottomRight")
        perspectiveCorrection.setValue(beginImage, forKey: kCIInputImageKey)
        
        let resImage = perspectiveCorrection.outputImage!
        let cgiimg = context.createCGImage(resImage, from: resImage.extent)
        let croppedimg = UIImage(cgImage: cgiimg!, scale: captureImage.scale, orientation: captureImage.imageOrientation)
        imgView.image = croppedimg
        //performSegue(withIdentifier: "showPhoto", sender: croppedimg)
        
        }
        
        /*let finalImage = CIFilter(name: "CIColorControls", parameters: [kCIInputImageKey: outputImage, kCIInputBrightnessKey: NSNumber(value: 0.0), kCIInputSaturationKey: NSNumber(value: 0.0), kCIInputContrastKey: NSNumber(value: 1.14)])?.outputImage*/
        
        /*let filter = CIFilter(name: "CIColorControls", parameters: [kCIInputImageKey: outputImage as Any , kCIInputBrightnessKey: NSNumber(value: 0.0), kCIInputSaturationKey: NSNumber(value: 0.0), kCIInputContrastKey: NSNumber(value: 1.14)])*/
        
        //let filter = CIFilter(name: "CIColorControls")
        
    
    
    
}
