//
//  AnimatedMaskLabel.swift
//  SlideToMenu
//
//  Created by GujyHy on 2018/1/10.
//  Copyright © 2018年 GujyHy. All rights reserved.
//

import UIKit
@IBDesignable
class AnimatedMaskLabel: UIView {
 
    // 绘制梯度渐变
    let gradientLayer:CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // 起始位置
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5) // 结束位置
        
        // 渐变色
//        let colors = [UIColor.black.cgColor,
//                      UIColor.white.cgColor,
//                      UIColor.black.cgColor]
        // 更改成6种颜色
        let colors   = [
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.orange.cgColor,
            UIColor.cyan.cgColor,
            UIColor.red.cgColor,
            UIColor.yellow.cgColor
        ]
        
        // 颜色过度帧的位置
//        let locations = [0.25,0.5,0.75]
        let locations =  [
            0.0, 0.0, 0.0, 0.0, 0.0, 0.25
        ]
        
        
        gradientLayer.locations = locations as [NSNumber]
        
        gradientLayer.colors = colors
        
        return gradientLayer
    }()
    let textAttributes : [NSAttributedStringKey : AnyObject] = {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let tAttributes = [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Thin", size: 28.0)!,
                           NSAttributedStringKey.paragraphStyle:style]
        
        return tAttributes
        
    }()
    
    // text 属性
    @IBInspectable var text:String!{
        didSet{
            setNeedsLayout()
            // 创建空的图形对象
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
//            let nstext = text! as NSString
            text.draw(in: bounds, withAttributes: self.textAttributes)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //  创建空遮罩层
            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
            // 偏移1倍的bounds ，落在中间的位置上
            maskLayer.contents = image?.cgImage
     
            gradientLayer.mask = maskLayer
        }
    }
    
    override func layoutSubviews() {
        layer.borderColor = UIColor.green.cgColor
        // 效果分明，白色太刺眼，扩大渐变层 ,宽度扩大3倍
        self.gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y,
                                          width: bounds.size.width * 3, height: bounds.size.height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.addSublayer(self.gradientLayer)
        // 1
        let gradientAnimation       = CABasicAnimation(keyPath: "locations")
//        gradientAnimation.fromValue = [0.0, 0.0, 0.25]  // 黑白黑
//        gradientAnimation.toValue   = [0.75,1.0, 1.0]
        gradientAnimation.fromValue = [
            0.0, 0.0, 0.0, 0.0, 0.0, 0.25
        ]
        gradientAnimation.toValue   = [
            0.65, 0.8, 0.85, 0.9, 0.95, 1.0
        ]
        
        gradientAnimation.duration      = 3.0
        gradientAnimation.repeatCount   = Float.infinity // 无限大
        self.gradientLayer.add(gradientAnimation, forKey: nil)
            // 效果分明，白色太刺眼，扩大渐变层 ,宽度扩大3倍
        
        
    }

}
