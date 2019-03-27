//
//  ViewController.swift
//  IGImageViewer
//
//  Created by Huy Duong on 3/25/19.
//  Copyright © 2019 Huy Duong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var igImageViewer: IGImageViewer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize
        igImageViewer = IGImageViewer(frame: self.view.frame)
        
        // image pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        self.imageView.isUserInteractionEnabled = true;
        self.imageView?.addGestureRecognizer(pinchGesture)
        
        // image pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        panGesture.delegate = self
        self.imageView?.addGestureRecognizer(panGesture)
        
    }
    
    @objc func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer?) {
        print("did pinch")
        if recognizer?.state == .began {
            
            self.igImageViewer?.show(with: self.imageView.image, and: self.igImageViewer?.frame ?? CGRect.zero)
            
        } else {
            
            self.igImageViewer?.updateImage(withPinchGestute: recognizer)
        }
    }
    
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer?) {
        print("did pan")
        if recognizer?.state == .changed {
            if let point: CGPoint = recognizer?.translation(in: imageView?.superview) {
                self.igImageViewer?.updateImage(with: point)
            }
            recognizer?.setTranslation(CGPoint.zero, in: imageView?.superview)
        } else if recognizer?.state == .ended {
            self.igImageViewer?.updateImage(withPanGestute: recognizer)
        }
        
    }
    
    
    
}


// MARK: - IGImageViewerDelegate

extension ViewController: IGImageViewerDelegate {
    
    func didEndTransformAnimationImagePinchingViewer() {
        
    }
    
    func didCloseImagePinchingViewer() {
        
    }
}
