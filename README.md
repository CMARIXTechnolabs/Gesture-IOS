# Gesture-IOS #
<a target="_blank" href="LICENSE.md"><img src="https://img.shields.io/badge/licence-MIT-brightgreen.svg" alt="license : MIT"></a>
<a target="_blank" href="https://www.cmarix.com/ios-app-development-company-india.html"><img src="https://img.shields.io/badge/platform-iOS-blue.svg" alt="platform : iOS"></a>

## Core Features ##

- Pinch to zoom with two fingers.
- Rotate the image using two fingers.
- Move the image with two fingers.
- Blur effect for the navigation bar while zoom in the image.

## How it works ##
- User can take picture from camera or select image from Gallery.
- Set the selected image.
- Move or rotate the image inside the defined UIView with two fingers.
- Zoom in or Zoom out the image inside the same view.

![enter image description here](https://www.cmarix.com/git/Mobile/Gesture-IOS/Screenshot.gif)
   
## Purpose of this code  ##
- Many developers are facing a issue to move the image inside UIView without scrollview. To overcome this scenario, we have prepared this code for the iOS developer to make their life easy.
-   This code allow users to zoom in/out the image, move or rotate the image using two fingers without scroll view.
   
## Requirements ##
- iOS 11+
- XCode 10
- Swift 4.0 
   
## When you can use this code ##
- Whenever you are having a requirement of erasing on image, this code will be help you to zoom in/out the image using two fingers where it should not affect the erase operation.
   
## Code Snippet ##
**Step 1**: Add UIPanGestureRecognizer, UIPinchGestureRecognizer and UIRotationGestureRecognizer for UIImageView.

	override func viewDidLoad() {
		super.viewDidLoad()
		imgUse?.isUserInteractionEnabled = true
	
		// Rotation image
		let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotatedImage(_:)))
		imgUse.addGestureRecognizer(rotate)
		// Zoom image
		let pinchGetsture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchActionZoomImage))
		pinchGetsture.delegate = self
		imgUse?.addGestureRecognizer(pinchGetsture)
	
		// Move image
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panActionmoveImage))
		panGesture.delegate = self
		panGesture.minimumNumberOfTouches = 2
		panGesture.maximumNumberOfTouches = 2
		imgUse?.addGestureRecognizer(panGesture)
	}

**Step 2**: rotatedImage() method is used to rotate image identify the rotation state of image. If there is change in sender.state case, then it will rotate image as per touch points from user’s finger.

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

**Step 3**: pinchActionZoomImage() method is used to zoom in and zoom out image. In this method, two fingers are used to zoom in and zoom out the image. Zoom out can not be done beyond the actual size of image, if user will going to make it zoom out beyond the actual size, it will be reset to the actual size with bounce effect.

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
    

**Step 4**: panActionmoveImage() method will be used to move image in any part of screen using two fingers.

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

## Let us know! ##
We’d be really happy if you sent us links to your projects where you use our component. Just send an email to [biz@cmarix.com](mailto:biz@cmarix.com "biz@cmarix.com") and do let us know if you have any questions or suggestion regarding Gestures.

P.S. We’re going to publish more awesomeness examples on third party libaries, coding standards, plugins etc, in all the technology. Stay tuned!

## License ##

	MIT License
	
	Copyright © 2019 CMARIX TechnoLabs
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
