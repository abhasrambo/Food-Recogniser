//
//  ViewController.swift
//  Food Recogniser
//
//  Created by Abhas Kumar on 6/12/20.
//  Copyright © 2020 Abhas Kumar. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
             
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userCapturedImage = info[UIImagePickerController.InfoKey.originalImage] {
         imageView.image = userCapturedImage as! UIImage
            guard let ciImage = CIImage(image: userCapturedImage as! UIImage) else {
                fatalError("Could not convert toCIImage")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Detecting image byModel failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Request to Model fail")
            }
           
            if let highestIdenttifiedObject = results.first {
//               print(highestIdenttifiedObject.identifier.count)
//                print(highestIdenttifiedObject.identifier)
                self.navigationItem.title = highestIdenttifiedObject.identifier
            }

        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
           try handler.perform([request])
        } catch {print(error)}
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    

}

