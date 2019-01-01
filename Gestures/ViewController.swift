//
//  ViewController.swift
//  Gestures
//
//  Created by CTPLMac7 on 20/12/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import UIKit


class ViewController: UIViewController  {
    
    @IBOutlet var btnGallery:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for subView in (self.navigationController?.navigationBar.subviews)! {
            if subView is UIVisualEffectView {
                subView.removeFromSuperview()
            }
        }
        
    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    @IBAction func btnClick(_ sender: UIButton)
    {
        self.presentImagePickerController(allowEditing: false) { (image, imageInfo) in
            if let originalImg = imageInfo![UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let usePhotoViewController = mainStoryBoard.instantiateViewController(withIdentifier: "UsePhotoViewController") as! UsePhotoViewController
                usePhotoViewController.selectedImg = originalImg
                self.navigationController?.pushViewController(usePhotoViewController, animated: false)
            }
        }
    }
}

