//
//  IGImageViewer.swift
//  IGImageViewer
//
//  Created by Huy Duong on 3/25/19.
//  Copyright © 2019 Huy Duong. All rights reserved.
//

import UIKit

protocol IGImageViewerDelegate: class {
    func didEndTransformAnimationImagePinchingViewer()
    func didCloseImagePinchingViewer()
}

class IGImageViewer: UIView {
    
    // MARK: - Outlet
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    
    // MARK: - Properties
    
    weak var delegate: IGImageViewerDelegate?
    
    private let DURATION_POPUP: Double = 0.4;
    private var originalFrame = CGRect.zero
    private var shouldPinch = false
    //    private var progressHUD: MBProgressHUD?
    
    
    // MARK: - Custom Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    
    func customInit() {
        if let object = Bundle.main.loadNibNamed("IGImageViewer", owner: self, options: nil)?[0] as? UIView {
            contentView = object
        }
        
        let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        contentView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        addSubview(contentView)
        
        shouldPinch = false
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    
    // MARK: - Helper Public Methods
    
    func show(with image: UIImage?, and frame: CGRect) {
        
        imageView?.image = nil
        imageView?.frame = frame
        originalFrame = frame
        UIApplication.shared.keyWindow?.addSubview(self)
        alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: DURATION_POPUP, animations: {
            self.alpha = 1.0
        })
        
        if image != nil {
            self.shouldPinch = true
            self.imageView?.image = image
        }
        
    }
    
    
    // MARK: - Helper Private Methods
    
    func updateImage(withPinchGestute gesture: UIPinchGestureRecognizer?) {
        
        if gesture?.state == .changed {
            
            if shouldPinch == false {
                return
            }
            
            // change color
            let minAlpha: CGFloat = 0.4
            let maxAlpha: CGFloat = 0.8
            let minScale: CGFloat = 1.0
            let maxScale: CGFloat = 1.4
            
            let colorRange: CGFloat = maxAlpha - minAlpha
            let scaleRange: CGFloat = maxScale - minScale
            
            let ratioScale: CGFloat = (imageView?.frame.width ?? 0) / originalFrame.size.width
            if ratioScale < 1.0 {
                gesture?.scale = 1.0
                //self.imageView.transform = CGAffineTransformScale(self.imageView.transform, 1.0, 1.0);
                imageView?.transform = .identity
                return
            }
            
            var alpha: CGFloat = minAlpha
            if ratioScale > maxScale {
                // limit max alpha
                alpha = maxAlpha
            } else if ratioScale < minScale {
                // limit min alpha
                alpha = minAlpha
            } else {
                // calculate alpha
                let ratio: CGFloat = (ratioScale - minScale) / scaleRange
                alpha = minAlpha + (ratio * colorRange)
            }
            contentView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            
            // scale image
            let scale: CGFloat = gesture?.scale ?? 1.0
            if let transformImage = imageView?.transform.scaledBy(x: scale, y: scale) {
                imageView?.transform = transformImage
            }
            gesture?.scale = 1.0
            
        } else if gesture?.state == .ended {
            
            closeView()
            
        }
        
    }
    
    
    func updateImage(withPanGestute gesture: UIPanGestureRecognizer?) {
        
        if gesture?.state == .ended {
            UIView.animate(withDuration: DURATION_POPUP, animations: {
                self.imageView?.transform = .identity
                self.imageView?.frame = self.originalFrame
            })
        }
    }
    
    
    func updateImage(with point: CGPoint) {
        imageView?.center = CGPoint(x: (imageView?.center.x ?? 0.0) + point.x, y: (imageView?.center.y ?? 0.0) + point.y)
    }
    
    
    func closeView() {
        
        UIView.animate(withDuration: DURATION_POPUP, animations: {
            self.imageView?.transform = .identity
            //self.imageView.frame = self->originalFrame;
            
        }) { finished in
            
            self.delegate?.didEndTransformAnimationImagePinchingViewer()
            
            UIView.animate(withDuration: self.DURATION_POPUP, animations: {
                self.alpha = 0.0
            }) { finished in
                self.delegate?.didCloseImagePinchingViewer()
                self.isHidden = true
                self.removeFromSuperview()
            }
        }
    }
    
    
}


