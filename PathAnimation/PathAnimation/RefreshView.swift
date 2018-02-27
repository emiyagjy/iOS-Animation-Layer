//
//  RefreshView.swift
//  PathAnimation
//
//  Created by GujyHy on 2018/1/11.
//  Copyright © 2018年 GujyHy. All rights reserved.
//

import UIKit
// MARK: Refresh View Delegate Protocol
protocol RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView)
}

class RefreshView: UIView , UIScrollViewDelegate{
    
    var delegate: RefreshViewDelegate?
    var scrollView: UIScrollView?
    var refreshing: Bool  = false
    var progress: CGFloat = 0.0
    
    var isRefreshing   = false
    
    let ovalShapeLayer = CAShapeLayer()
    let airplaneLayer  = CALayer()
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        
        self.scrollView = scrollView
        
        //add the background image
        let imgView = UIImageView(image: UIImage(named: "refresh-view-bg.png"))
        imgView.frame = bounds
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        addSubview(imgView)
        
        self.ovalShapeLayer.fillColor        = UIColor.clear.cgColor
        self.ovalShapeLayer.strokeColor      = UIColor.white.cgColor
        self.ovalShapeLayer.lineWidth        = 4
        self.ovalShapeLayer.lineDashPattern  = [2, 3]    // 设置虚线线段的长度2 和 空格的长度3
        
        let refreshRadius = bounds.size.height / 2 * 0.8 // 半径
        let refreshRect   = CGRect(x: bounds.width  / 2 - refreshRadius,
                                   y: bounds.height / 2 - refreshRadius,
                                   width: refreshRadius * 2, height: refreshRadius * 2)
        let refeshPath    = UIBezierPath(ovalIn: refreshRect).cgPath
        self.ovalShapeLayer.path = refeshPath
        
        self.layer.addSublayer(self.ovalShapeLayer)
        
        let image = UIImage(named: "airplane")!
        self.airplaneLayer.contents = image.cgImage
        self.airplaneLayer.bounds   = CGRect(x: 0, y: 0,
                                            width: image.size.width, height: image.size.height)
         // 位置，圆的起点位置
        self.airplaneLayer.position = CGPoint(x: frame.size.width  / 2 + refreshRadius,
                                              y: frame.size.height / 2)
        self.layer.addSublayer(self.airplaneLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView.contentInset.top = 64 ?
        let offsetY = CGFloat( max(-(scrollView.contentOffset.y + 64), 0.0))
        self.progress = min(max(offsetY / frame.size.height, 0.0), 1.0)
        
        if !isRefreshing {
            redrawFromProgress(progress: self.progress)
        }
    }
    
 
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        if !isRefreshing && self.progress >= 1.0 {
            delegate?.refreshViewDidRefresh(refreshView: self)
            beginRefreshing()
        }
    }
    
    // MARK: animate the Refresh View
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animate(withDuration: 0.3, animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top += self.frame.size.height
            self.scrollView!.contentInset = newInsets
        })
        
        //  创建动画指示器
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5  // 在同样的时间能内 能容动画执行的越快，算是一个小技巧
        strokeStartAnimation.toValue   = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue   = 1.0
        
        let strokeAnimationGroup          = CAAnimationGroup()
        strokeAnimationGroup.duration     = 1.5
        strokeAnimationGroup.repeatCount  = 5
        strokeAnimationGroup.animations   = [strokeStartAnimation,strokeEndAnimation]
        
        self.ovalShapeLayer.add(strokeAnimationGroup, forKey: nil)
        
        // 创建飞机飞行的 帧 动画
        let fightAnimation   = CAKeyframeAnimation(keyPath: "position")
        fightAnimation.path  = self.ovalShapeLayer.path
        fightAnimation.calculationMode = kCAAnimationPaced
        // calculation mode  另一个是控制动画时间的方式 ,
        // kCAAnimationPaced = 层动画忽略其他关键点的时间设置,使用平均速度
        
        let airplaneOrientationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        airplaneOrientationAnimation.fromValue  = 0
        airplaneOrientationAnimation.toValue    = Double.pi * 2
        // 从0 旋转到 2pai 360 度
        let fightAnimationGroup          = CAAnimationGroup()
        fightAnimationGroup.duration     = 1.5
        fightAnimationGroup.repeatCount  = 5
        fightAnimationGroup.animations   = [fightAnimation, airplaneOrientationAnimation]
        
        self.airplaneLayer.add(fightAnimationGroup, forKey: nil)
        
    }
    func endRefreshing() {
        isRefreshing = false
        
        UIView.animate(withDuration: 0.3, delay:0.0, options: .curveEaseOut ,animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top -= self.frame.size.height
            self.scrollView!.contentInset = newInsets
        }, completion: {_ in
            //finished
            self.airplaneLayer.removeAllAnimations()
            self.ovalShapeLayer.removeAllAnimations()
        })
    }
    
    func redrawFromProgress(progress: CGFloat){
        print(progress)
        self.ovalShapeLayer.strokeEnd = progress
        self.airplaneLayer.opacity = Float(progress)
    }
    
}
