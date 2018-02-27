//
//  AvatarView.swift
//  ShapeSqueezingAnimation
//
//  Created by GujyHy on 2018/1/10.
//  Copyright © 2018年 GujyHy. All rights reserved.
//

import UIKit

@IBDesignable
class AvatarView: UIView {

    // MARK: Constants
    let LINE_WIDTH:CGFloat = 6.0
    let ANIMAION_DURING    = 1.0
    
    // MARK: UI
    let photoLayer  = CALayer()
    let circleLayer = CAShapeLayer()
    let maskLayer   = CAShapeLayer()
    let label : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    

    // MARK: Variables
    @IBInspectable
    var image : UIImage! {
        didSet {
            self.photoLayer.contents = image.cgImage
        }
    }
    @IBInspectable
    var name: String? {
        didSet {
            self.label.text = name
        }
    }
    
    //  定义一个变量，默认为false，当为true就停止碰撞动画
    var shouldTransitonFinishedState = false
    var isSquare = false
    
    override func layoutSubviews() {
        // photo iamge
        self.photoLayer.frame = CGRect(x: (bounds.size.width  - image.size.width  + LINE_WIDTH) / 2 ,
                                       y: (bounds.size.height - image.size.height - LINE_WIDTH) / 2 ,
                                       width: image.size.width, height: image.size.height)
        
        // 贝塞尔曲线生成的椭圆路径
        self.circleLayer.path        = UIBezierPath(ovalIn: bounds).cgPath
        self.circleLayer.strokeColor = UIColor.white.cgColor
        self.circleLayer.fillColor   = UIColor.clear.cgColor
        self.circleLayer.lineWidth   = LINE_WIDTH
        
        self.maskLayer.path     = self.circleLayer.path
        self.maskLayer.position = CGPoint(x: 0.0, y: 10.0)
        
        // size the label
        self.label.frame = CGRect(x: 0.0,
                                  y: bounds.size.height + 10.0 ,
                                  width: bounds.size.width, height: 24.0)
    }
    
    override func didMoveToWindow() {
        self.layer.addSublayer(self.photoLayer)
        
        self.photoLayer.mask = self.maskLayer
        self.layer.addSublayer(self.circleLayer)
        
        self.addSubview(self.label)
    }
    
    // MARK : Publc
    
    /// 实现冲撞后的反弹动画
    ///
    /// - Parameters:
    ///   - bouncePoint: 反弹的坐标
    ///   - morphSize:   重装后大小的变化
    func bounceOffPoint(bouncePoint:CGPoint, morphSize:CGSize) {
        let originalCenter = self.center // 保持原始坐标
        
        // 使用弹簧动画实现 反弹的效果
        UIView.animate(withDuration: ANIMAION_DURING, delay: 0.0,
                       usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0,
                       options: [], animations: {
                            self.center = bouncePoint
                       }, completion: { _ in
                            if self.shouldTransitonFinishedState {
                                self.amimteToSquare()
                            }
                       })
        
        UIView.animate(withDuration: ANIMAION_DURING, delay: ANIMAION_DURING,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0,
                       options: [], animations: {
                        self.center = originalCenter
                        }, completion: { _ in
                            // 如果 isSquare 不为真的情况下 ，继续调用碰撞动画
                            if !self.isSquare {
                                self.bounceOffPoint(bouncePoint: bouncePoint, morphSize: morphSize)
                            }
                        })
        
        // 原始位置 > 反弹位置 右———>左就是自己的头像，反之 从左——>右就是对手的头像
        // 图层的位置
        let morphFrame = originalCenter.x > bouncePoint.x ?
         CGRect(x: 0.0, y: bounds.size.height - morphSize.height,
                width: morphSize.width, height: morphSize.height) :
            
         CGRect(x: bounds.size.width - morphSize.width,
                y: bounds.size.height - morphSize.height,
                width: morphSize.width, height: morphSize.height)
        
        let morphAnimation = CABasicAnimation(keyPath: "path")
        morphAnimation.duration = ANIMAION_DURING
        morphAnimation.toValue  = UIBezierPath(ovalIn: morphFrame).cgPath
        morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // 缓出
        self.circleLayer.add(morphAnimation, forKey: nil)
        self.maskLayer.add(morphAnimation, forKey: nil)
        
    }
    
    func amimteToSquare(){
        self.isSquare = true
        
        let squarePath = UIBezierPath(rect: bounds).cgPath
        let morphAnima = CABasicAnimation(keyPath: "path")
        morphAnima.duration  = 0.25
        morphAnima.fromValue = circleLayer.path
        morphAnima.toValue   = squarePath
        
        self.circleLayer.add(morphAnima, forKey: nil)
        self.maskLayer.add(morphAnima, forKey: nil)
        
        self.circleLayer.path = squarePath
        self.maskLayer.path   = squarePath
        
    }
    

}
