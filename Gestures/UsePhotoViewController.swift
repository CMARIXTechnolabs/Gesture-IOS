//
//  UsePhotoViewController.swift
//
//
//  Created by CTPLMac7 on 23/08/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import UIKit

class UsePhotoViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var selectedImg: UIImage?
    @IBOutlet weak var imgUse:UIImageView!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var mainVwHeightConstraint: NSLayoutConstraint!
    var currentTransform: CGAffineTransform? = nil
    var pinchStartImageCenter: CGPoint = CGPoint(x: 0, y: 0)
    let maxScale: CGFloat = 6.0
    let minScale: CGFloat = 1.0
    var currentScale: CGFloat = 1.0
    var pichCenter: CGPoint = CGPoint(x: 0, y: 0)
    var lastRotation : CGFloat = 0.0
    var previousScale : CGFloat = 1.0
    var beginX : CGFloat = 0.0
    var beginY : CGFloat = 0.0
    var lastScale:CGFloat!
    var frameActual = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.installBlurEffect()
        
        imgUse?.isUserInteractionEnabled = true
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotatedImage(_:)))
        imgUse.addGestureRecognizer(rotate)
        
        let pinchGetsture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchActionZoomImage))
        pinchGetsture.delegate = self
        imgUse?.addGestureRecognizer(pinchGetsture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panActionmoveImage))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        imgUse?.addGestureRecognizer(panGesture)
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE
        {
            
            mainVwHeightConstraint.constant = 392
            imgUse.frame = CGRect(x: 0, y: 0, width:320 , height: 392)
        }
        else if UIDevice.current.screenType == .iPhones_6_6s_7_8
        {
            mainVwHeightConstraint.constant = 460
            imgUse.frame = CGRect(x: 0, y: 0, width:375 , height: 460)
        }
        else if UIDevice.current.screenType == .iPhones_6Plus_6sPlus_7Plus_8Plus
        {
            mainVwHeightConstraint.constant = 529
            imgUse.frame = CGRect(x: 0, y: 0, width:414 , height: 508)
        }
        else if UIDevice.current.screenType == .iPhones_X_XS
        {
            mainVwHeightConstraint.constant = 540
            imgUse.frame = CGRect(x: 0, y: 0, width:375 , height: 540)
        }
        else if UIDevice.current.screenType == .iPhone_XR_XSMax
        {
            mainVwHeightConstraint.constant = 596
            imgUse.frame = CGRect(x: 0, y: 0, width:414 , height: 596)
        }
        
        
        imgUse.image = selectedImg
        setNavigationBar()
        
        self.frame(for:selectedImg!, inImageViewAspectFit: imgUse)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func frame(for image: UIImage, inImageViewAspectFit imageView: UIImageView) -> CGRect {
        let imageRatio = (image.size.width / image.size.height)
        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
        if imageRatio < viewRatio {
            let scale = imageView.frame.size.height / image.size.height
            let width = scale * image.size.width
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            imgUse.frame = CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
            containerView.center = imgUse.center
            print("Image used frame second\(imgUse.frame.size)")
            frameActual = imgUse.frame
            
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        } else {
            
            let scale = imageView.frame.size.width / image.size.width
            let height = scale * image.size.height
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            imgUse.frame = CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
            containerView.center = imgUse.center
            print("Image used frame second\(imgUse.frame.size)")
            frameActual = imgUse.frame
            
            return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
        
    }
    
    func setNavigationBar() {
        
        let leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(onclickBack))
        leftBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    // Image zoom in and zoom out
    @objc func pinchActionZoomImage(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.began { // Begin pinch
            // Store current transfrom of UIImageView
            self.currentTransform = imgUse.transform
            
            // Store initial loaction of pinch action
            self.pinchStartImageCenter = imgUse.center
            
            let touchPoint1 = gesture.location(ofTouch: 0, in: imgUse)
            let touchPoint2 = gesture.location(ofTouch: 1, in: imgUse)
            
            // Get mid point of two touch
            self.pichCenter = CGPoint(x: (touchPoint1.x + touchPoint2.x) / 2, y: (touchPoint1.y + touchPoint2.y) / 2)
            lastScale = gesture.scale
            
        } else if gesture.state == UIGestureRecognizer.State.changed { // Pinching in operating
            // Store scale
            
            let pinchCenter = CGPoint(x: gesture.location(in: imgUse).x - imgUse.bounds.midX,
                                      y: gesture.location(in: imgUse).y - imgUse.bounds.midY)
            let transform = imgUse.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: gesture.scale, y: gesture.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            imgUse.transform = transform
            gesture.scale = 1
            
        }
        if gesture.state == UIGestureRecognizer.State.ended { // End pinch
            // Get current scale
            var tmpScale: CGFloat = 1.0
            var scaleUpdated = false
            
            let currentScale = sqrt(abs(imgUse.transform.a * imgUse.transform.d - imgUse.transform.b * imgUse.transform.c))
            if currentScale <= self.minScale { // Under lower scale limit
                tmpScale = self.minScale
                scaleUpdated = true
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    
                    self.imgUse.center = CGPoint(x: self.imgUse.frame.size.width / 2, y: self.imgUse.frame.size.height / 2)
                    self.imgUse.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
                    self.imgUse.frame = self.frameActual
                    
                    
                }, completion: {(finished: Bool) -> Void in
                })
            } else if self.maxScale <= currentScale { // Upper higher scale limit
                tmpScale = self.maxScale
                scaleUpdated = true
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    
                    
                }, completion: {(finished: Bool) -> Void in
                })
            }
        }
    }
    // Rotation image
    @objc func rotatedImage(_ sender: UIRotationGestureRecognizer) {
        
        guard let view = sender.view else { return }
        
        switch sender.state {
        case .changed:
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        default: break
        }
        
    }
    
    @objc func onclickBack()
    {
        self.navigationController?.popViewController(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func panActionmoveImage(gesture: UIPanGestureRecognizer) {
        
        // Store current transfrom of UIImageView
        let transform = imgUse.transform
        
        // Initialize imageView.transform
        imgUse.transform = CGAffineTransform.identity
        
        // Move UIImageView
        let point: CGPoint = gesture.translation(in: imgUse)
        let movedPoint = CGPoint(x: imgUse.center.x + point.x,
                                 y: imgUse.center.y + point.y)
        imgUse.center = movedPoint
        
        // Revert imageView.transform
        imgUse.transform = transform
        
        // Reset translation
        gesture.setTranslation(CGPoint.zero, in: imgUse)
        
    }
    
    
    
}
var blurView: UIVisualEffectView!

extension UINavigationBar {
    
    func installBlurEffect() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        //        blurView.alpha = 0.72
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if !self.subviews.contains(blurView) {
            addSubview(blurView)
        }
        blurView.layer.zPosition = -1
    }
    
    
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.bounds.height >= 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_XSMax = "iPhone XR"
        
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.bounds.height {
        case 480:
            return .iPhones_4_4S
        case 568:
            return .iPhones_5_5s_5c_SE
        case 667:
            return .iPhones_6_6s_7_8
        case 896:
            return .iPhone_XR_XSMax
        case 736:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 812:
            return .iPhones_X_XS
        default:
            return .unknown
        }
    }
}
