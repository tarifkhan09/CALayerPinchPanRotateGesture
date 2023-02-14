//
//  ViewController.swift
//  CALayerPinchPanRotateGesture
//
//  Created by MD Tarif khan on 14/2/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gestureView: UIView!
    
    var imageLayer = CALayer()
    var borderlayer = CALayer()
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let overImage = UIImage(named: "flower.jpg")
        
        imageLayer.frame = CGRect(x: 50, y: 50, width: gestureView.frame.width - 100, height: gestureView.frame.height - 100)
        imageLayer.contents = overImage?.cgImage
        imageLayer.contentsGravity = .resizeAspect
        gestureView.layer.addSublayer(imageLayer)
        
        let bframe = AVMakeRect(aspectRatio: overImage!.size,
                                insideRect: imageLayer.frame)
        
        borderlayer.frame = bframe
        //        CGRectApplyAffineTransform(imageLayer.bounds, CGAffineTransform(scaleX: 1.02, y: 1.02))
        borderlayer.borderColor = UIColor.red.cgColor
        borderlayer.borderWidth = 1
        borderlayer.position = gestureView.center
        self.view.layer.addSublayer(borderlayer)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        
        caTransactionSet()
        let scale = sender.scale
        let affineTransform = CGAffineTransformScale(borderlayer.affineTransform(), scale, scale)
        let transform3D = CATransform3DMakeAffineTransform(affineTransform)
        borderlayer.transform = transform3D
        imageLayer.transform = transform3D
        sender.scale = 1
        
        CATransaction.commit()
        
    }
        
    @IBAction func rotationGesture(_ sender: UIRotationGestureRecognizer) {
        
        caTransactionSet()
        let rotation = sender.rotation
        sender.rotation = 0
        sender.reset()
        
        imageLayer.transform = CATransform3DMakeAffineTransform(
            CGAffineTransformRotate(imageLayer.affineTransform() ,rotation)
        )
        
        borderlayer.transform = CATransform3DMakeAffineTransform(
            CGAffineTransformRotate(borderlayer.affineTransform() ,rotation)
        )
        
        CATransaction.commit()
    }
    
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        
        caTransactionSet()
        let translation = sender.translation(in: self.view)
        borderlayer.position = CGPoint(x: translation.x + borderlayer.position.x,
                                       y: (translation.y) + borderlayer.position.y)
        
        imageLayer.position = CGPoint(x: translation.x + imageLayer.position.x,
                                      y: (translation.y) + imageLayer.position.y)
        
        sender.setTranslation(.zero, in: self.view)
        CATransaction.commit()
    }
    
    func caTransactionSet(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
    }
}

