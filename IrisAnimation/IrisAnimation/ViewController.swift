//
//  ViewController.swift
//  IrisAnimation
//
//  Created by GujyHy on 2018/1/11.
//  Copyright © 2018年 GujyHy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let replicatorLayer:CAReplicatorLayer = CAReplicatorLayer()
    let dot = CALayer()
    
    let dotLength: CGFloat = 6.0
    let dotOffset: CGFloat = 8.0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        replicatorLayer.frame = self.view.bounds
        view.layer.addSublayer(replicatorLayer)
        
        dot.frame =  CGRect(x: replicatorLayer.frame.size.width - dotLength,
                            y: replicatorLayer.position.y,
                            width: dotLength, height: dotLength)
        dot.backgroundColor = UIColor.lightGray.cgColor
        dot.borderColor     = UIColor(white: 1.0, alpha: 1.0).cgColor
        dot.borderWidth     = 0.5
        dot.cornerRadius    = 1.5
        
        replicatorLayer.addSublayer(dot)
        
        replicatorLayer.instanceCount     = Int(view.frame.size.width / dotOffset)
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(-dotOffset, 0, 0)  // 从右开始偏移 8.0
        replicatorLayer.instanceDelay     = 0.02
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func speakButtonAction(_ sender: Any) {
        
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scale.toValue = NSValue(caTransform3D:
            CATransform3DMakeScale(1.4, 15, 1.0)) // 水平1.4 ,垂直15，z方向不变1.0
        scale.duration = 0.33
        scale.repeatCount = Float.infinity
        scale.autoreverses = true
        scale.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseOut)
        dot.add(scale, forKey: "dotScale")
        
        // 渐变
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1.0
        fade.toValue = 0.2
        fade.duration = 0.33
        fade.beginTime = CACurrentMediaTime() + 0.33
        fade.repeatCount = Float.infinity
        fade.autoreverses = true
        fade.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseOut)
        dot.add(fade, forKey: "dotOpacity")
        
        // 颜色
        let tint = CABasicAnimation(keyPath: "backgroundColor")
        tint.fromValue = UIColor.magenta.cgColor
        tint.toValue = UIColor.cyan.cgColor
        tint.duration = 0.66
        tint.beginTime = CACurrentMediaTime() + 0.28
        tint.fillMode = kCAFillModeBackwards
        tint.repeatCount = Float.infinity
        tint.autoreverses = true
        tint.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        dot.add(tint, forKey: "dotColor")
        
        // 旋转克隆体 第一个旋转动画
        let initialRotation = CABasicAnimation(keyPath:
            "instanceTransform.rotation")
        initialRotation.fromValue = 0.0
        initialRotation.toValue   = 0.01
        initialRotation.duration = 0.33
        initialRotation.isRemovedOnCompletion = false
        initialRotation.fillMode = kCAFillModeForwards
        initialRotation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseOut)
        replicatorLayer.add(initialRotation, forKey:
            "initialRotation")
        
          // 第二个旋转动画 在 第一个旋转动画的后面 ，0.01 -> -0.01
        let rotation = CABasicAnimation(keyPath:
            "instanceTransform.rotation")
        rotation.fromValue = 0.01
        rotation.toValue   = -0.05
        rotation.duration = 0.99
        rotation.beginTime = CACurrentMediaTime() + 0.33
        rotation.repeatCount = Float.infinity
        rotation.autoreverses = true
        rotation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        replicatorLayer.add(rotation, forKey: "replicatorRotation")
        
        
    }


}

