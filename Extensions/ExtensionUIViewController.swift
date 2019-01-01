//
//  ExtensionUIViewController.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI

var AlertBlockKey: UInt8 = 0

// MARK: A type for our action block closure

typealias BlockButtonActionBlock = (_ sender: UIButton) -> Void
typealias BlockAlertBlock = (_ buttonIndexs: Int) -> Void
typealias BlockAlertOkAction = (_ action: UIAlertAction) -> Void
typealias alertActionHandler = ((UIAlertAction) -> ())?

// MARK: Convert all action block closure to variable object

class AlertBlockWrapper : NSObject
{
    var block : BlockAlertBlock
    init(block: @escaping BlockAlertBlock)
    {
        self.block = block
    }
}

var sortedContactKeys = [String]()

var objImagePickerController: UIImagePickerController?

extension UIViewController: UIAlertViewDelegate
{

    func presentAlertViewWithTwoButtons(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:
    // MARK: Use for alert messages
    // MARK:
    
    func showAlert(_ message: String) -> Void
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alertWithTitle(_ title: String, message: String) -> Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showWithOkAction(title: String?, message: String?, cancelTitle: String, other: NSArray?,clicked: @escaping BlockAlertOkAction) -> Void {
        
        if #available(iOS 9.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: clicked))
            
            if other != nil {
                for addButton in other! {
                    let OKAction = UIAlertAction(title: String(describing: addButton), style: .default) { (action) in
                        let index = other?.index(of: action.title!)
                        let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                        wrapper.block(index!)
                    }
                    alertController.addAction(OKAction)
                }
            }
            
            self.present(alertController, animated: true) {
                
            }
        } else {
            let alert:UIAlertView = UIAlertView()
            
            if (title != nil)
            {
                alert.title = title!
            }
            if (message != nil)
            {
                alert.message = message!
            }
            alert.addButton(withTitle: cancelTitle)
            if (other != nil)
            {
                for addButton in other! {
                    alert.addButton(withTitle: String(describing: addButton))
                }
            }
            
            alert.delegate = self
            alert.show()
        }
        
    }
    
    func show(title: String?, message: String?, cancelTitle: String, other: NSArray?,clicked: @escaping BlockAlertBlock) -> Void {
        
        if #available(iOS 9.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
                let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                wrapper.block(0)
            }
            alertController.addAction(cancelAction)
            
            if other != nil {
                for addButton in other! {
                    let OKAction = UIAlertAction(title: String(describing: addButton), style: .default) { (action) in
                        var index = other?.index(of: action.title!)
                        index = index! + 1
                        let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                        wrapper.block(index!)
                    }
                    alertController.addAction(OKAction)
//                    objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
            
            objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.present(alertController, animated: true) {
                
            }
        } else {
            let alert:UIAlertView = UIAlertView()
            
            if (title != nil)
            {
                alert.title = title!
            }
            if (message != nil)
            {
                alert.message = message!
            }
            alert.addButton(withTitle: cancelTitle)
            
            
            if (other != nil)
            {
                for addButton in other! {
                    alert.addButton(withTitle: String(describing: addButton))
                }
            }
            
            objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            alert.delegate = self
            alert.show()
        }
    }
    
    // MARK:
    // MARK: Use for open acction sheet
    // MARK:
    
    func showActionSheet(title: String?, message: String?, cancelTitle: String, other: NSArray?,clicked: @escaping BlockAlertBlock) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
            wrapper.block(-1)
        }
        alertController.addAction(cancelAction)
        
        if other != nil {
            for addButton in other! {
                let OKAction = UIAlertAction(title: String(describing: addButton), style: .default) { (action) in
//                    print(action.title!)
                    let index  = other?.index(of: action.title!)
                    let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                    wrapper.block(index!)
                }
                alertController.addAction(OKAction)
            }
        }
        
        objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true) {
            
        }
    }
    
    func presentActionsheetWithTwoButtons(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertAction.Style , btnOneTapped:alertActionHandler , btnTwoTitle:String  , btnTwoStyle:UIAlertAction.Style , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: btnTwoStyle, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}


extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
    }
    
    public func hideTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
}


typealias imagePickerControllerCompletionHandler = ((_ image:UIImage? , _ info:[UIImagePickerController.InfoKey : Any]?) -> ())

// MARK: - Extension of UIViewController For UIImagePickerController - Select Image From Camera OR PhotoLibrary

extension UIViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        
        static var imagePickerController = "imagePickerController"
        static var imagePickerControllerCompletionHandler = "imagePickerControllerCompletionHandler"
    }
    
    /// A Computed Property of UIImagePickerController , If its already in memory then return it OR not then create new one and store it in memory reference.
    private var imagePickerController:UIImagePickerController? {
        
        if let imagePickerController = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerController) as? UIImagePickerController {
            
            return imagePickerController
        } else {
            return self.addImagePickerController()
        }
    }
    
    /// A Private method used to create a UIImagePickerController and store it in a memory reference.
    ///
    /// - Returns: return a newly created UIImagePickerController.
    private func addImagePickerController() -> UIImagePickerController? {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerController, imagePickerController, .OBJC_ASSOCIATION_RETAIN)
        
        return imagePickerController
    }
    
    /// A Private method used to set the sourceType of UIImagePickerController
    ///
    /// - Parameter sourceType: A Enum value of "UIImagePickerControllerSourceType"
    private func setImagePickerControllerSourceType(sourceType:UIImagePickerController.SourceType) {
        
        self.imagePickerController?.sourceType = sourceType
    }
    
    /// A Private method used to set the Bool value for allowEditing OR Not on UIImagePickerController.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func setAllowEditing(allowEditing:Bool) {
        self.imagePickerController?.allowsEditing = allowEditing
    }
    
    /// This method is used to present the UIImagePickerController on CurrentController for select the image from Camera or PhotoLibrary.
    ///
    /// - Parameters:
    ///   - allowEditing: Pass the Bool value for allowEditing OR Not on UIImagePickerController.
    ///   - imagePickerControllerCompletionHandler: This completionHandler contain selected image AND info Dictionary to let you help in CurrentController. Both image AND info Dictionary might be nil , in this case to prevent the crash please use if let OR guard let.
    func presentImagePickerController(allowEditing:Bool , imagePickerControllerCompletionHandler:@escaping imagePickerControllerCompletionHandler) {
        
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: "Take A Photo", btnOneStyle: .default, btnOneTapped: { (action) in
            
            self.takeAPhoto()
            
        }, btnTwoTitle: "Choose From Gallery", btnTwoStyle: .default) { (action) in
            
            self.chooseFromPhone(allowEditing:allowEditing)
        }
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler:@escaping imagePickerControllerCompletionHandler) {
        self.takeAPhoto()
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /// A private method used to select the image from camera.
    private func takeAPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            self.setImagePickerControllerSourceType(sourceType: .camera)
            self.setAllowEditing(allowEditing: false)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {
            
            self.showAlert("Your device does not support camera")
//            self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: "Your device does not support camera", btnOneTitle: "Ok", btnOneTapped: nil)
        }
    }
    
    /// A private method used to select the image from photoLibrary.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func chooseFromPhone(allowEditing:Bool) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            self.setImagePickerControllerSourceType(sourceType: .photoLibrary)
            self.setAllowEditing(allowEditing: allowEditing)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {}
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            
            if let allowEditing = self.imagePickerController?.allowsEditing {
                
                var image:UIImage?
                
                if allowEditing {
                    
                    image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                    
                } else {
                    
                    image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                }
                
                if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                    
                    imagePickerControllerCompletionHandler(image, info)
                }
            }
        }
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            
            if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                
                imagePickerControllerCompletionHandler(nil, nil)
            }
        }
    }
    
}

enum PHAssetType : Int {
    case unknown
    case image
    case video
    case audio
}


typealias phAssetControllerHandler = ((_ mediaItemCollection:PHFetchResult<PHAsset>?) -> ())
// MARK: - Extension of UIViewController For MPMediaPickerController - Select Video/Image From gallery
extension UIViewController {
    /// This Private Structure is used to create all AssociatedAssetKey which will be used within this extension.
    private struct AssociatedAssetKey {
        static var phAssetControllerHandler = "phAssetControllerHandler"
    }
    
    func phAssetController(_ type : PHAssetType?, phAssetControllerHandler:@escaping phAssetControllerHandler){
        
        objc_setAssociatedObject(self, &AssociatedAssetKey.phAssetControllerHandler, phAssetControllerHandler, .OBJC_ASSOCIATION_RETAIN)
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                var arrAssets = PHFetchResult<PHAsset>()
                switch type
                {
                case .unknown?:
                    arrAssets = PHAsset.fetchAssets(with: .unknown, options: fetchOptions)
                    
                case .image?:
                    arrAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                    
                case .video?:
                    arrAssets = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                    
                case .audio?:
                    arrAssets = PHAsset.fetchAssets(with: .audio, options: fetchOptions)
                    
                default:
                    break
                    
                }
                
                
                print("Found \(arrAssets.count) assets")
                
                if let phAssetControllerHandler = objc_getAssociatedObject(self, &AssociatedAssetKey.phAssetControllerHandler) as? phAssetControllerHandler {
                    phAssetControllerHandler(arrAssets)
                }
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            }
        }
        
    }
}
