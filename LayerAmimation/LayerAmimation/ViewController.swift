//
//  ViewController.swift
//  LayerAmimation
//
//  Created by GujyHy on 2018/1/8.
//  Copyright © 2018年 GujyHy. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CAAnimationDelegate{

    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var headLabel: UILabel!
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    @IBOutlet var loginButton: UIButton!
    
    let info = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        info.frame           = CGRect(x: 0.0, y: self.loginButton.center.y + 60.0,
                                      width: view.frame.size.width, height: 30)
        info.backgroundColor = UIColor.clear
        info.font            = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textAlignment   = .center
        info.textColor       = UIColor.white
        info.text            = "请在上面的框中输入用户名和密码"
        view.insertSubview(info, belowSubview: loginButton)
        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        username.layer.position.x -= self.view.bounds.width
//        password.layer.position.x -= self.view.bounds.width
        
//         let time: TimeInterval = 5.0
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
//            print("field 去哪里了")
//            // 呈现层的缓冲动画，幻象，一旦动画完成就会从屏幕上消失，真正的field才会显示出来
//        })
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        /// --------------  Layer 动画的实现  --------------
//        let flyRight = CABasicAnimation(keyPath: "position.x") // position 当前层位于父层的位置
//        flyRight.fillMode  = kCAFillModeBoth
//        flyRight.fromValue = -self.view.bounds.width / 2
//        flyRight.toValue   = self.view.bounds.width / 2
//        flyRight.duration  = 0.5
//        flyRight.delegate  = self  // 课时2
////        flyRight.isRemovedOnCompletion  = false  // 默认true，动画完成就是消失
//        // fillMode为kCAFillModeBoth时，再设成false 就能保持一旦动画结束，保持在原来的位置上面
//        // 但field 并没有功能，尽量不要用它，影响性能。
//        flyRight.setValue("form", forKey: "name")
//        flyRight.setValue(self.headLabel.layer, forKey: "layer")
//
//        self.headLabel.layer.add(flyRight, forKey: nil)
//
//        flyRight.beginTime = CACurrentMediaTime() + 0.3
//        flyRight.setValue(self.username.layer, forKey: "layer")
//        self.username.layer.add(flyRight, forKey: nil)
//
//        flyRight.beginTime = CACurrentMediaTime() + 0.4
//        flyRight.setValue(self.password.layer, forKey: "layer")
//        self.password.layer.add(flyRight, forKey: nil)
//
//        username.layer.position.x = self.view.bounds.width / 2
//        password.layer.position.x = self.view.bounds.width / 2
        
        /// --------------  分组动画表单提交 课时3  --------------
        let formGroup = CAAnimationGroup()
        formGroup.duration = 0.5
        formGroup.fillMode = kCAFillModeBackwards
        
        let flyRight       = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -self.view.bounds.width / 2
        flyRight.toValue   = self.view.bounds.width / 2
        
        let fadeFieldIn       = CABasicAnimation(keyPath: "opacity")
        fadeFieldIn.fromValue = 0.25
        fadeFieldIn.toValue   = 1.0
        
        formGroup.animations  = [flyRight,fadeFieldIn]
        self.headLabel.layer.add(formGroup, forKey: nil)
        
        // username,password
        formGroup.delegate   = self
        formGroup.setValue("form", forKey: "name")
        formGroup.setValue(username.layer, forKey: "layer")
        
        formGroup.beginTime  = CACurrentMediaTime() + 0.3
        username.layer.add(formGroup, forKey: nil)
        
        formGroup.setValue(password.layer, forKey: "layer")
        formGroup.beginTime  = CACurrentMediaTime() + 0.4
        password.layer.add(formGroup, forKey: nil)
        
        // fade
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue   = 1.0
        fadeIn.duration  = 0.5
        fadeIn.fillMode  = kCAFillModeBackwards
        fadeIn.beginTime = CACurrentMediaTime() + 0.5
        self.cloud1.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.7
        self.cloud2.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.9
        self.cloud3.layer.add(fadeIn, forKey: nil)
        
        fadeIn.beginTime = CACurrentMediaTime() + 1.1
        self.cloud4.layer.add(fadeIn, forKey: nil)
        
        
        // 动画组 运用于loginButton
        let groupAnmiation = CAAnimationGroup()
        groupAnmiation.beginTime      = CACurrentMediaTime() + 0.5
        groupAnmiation.duration       = 0.5
        groupAnmiation.fillMode       = kCAFillModeBackwards
        groupAnmiation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let scaleDown       = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue   = 1.0
        
        let rotate          = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue    = Double.pi / 4
        rotate.toValue      = 1.0

        let fade            = CABasicAnimation(keyPath: "opacity")
        fade.fromValue      = 0.0
        fade.toValue        = 1.0
        groupAnmiation.animations = [scaleDown,rotate,fade]
        self.loginButton.layer.add(groupAnmiation, forKey: nil)
        
        
        self.animateCloud(cloud1.layer)
        self.animateCloud(cloud2.layer)
        self.animateCloud(cloud3.layer)
        self.animateCloud(cloud4.layer)
        
        // info flyLeft
        let flyLeft          = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue    = info.layer.position.x + self.view.bounds.size.width
        flyLeft.toValue      = info.layer.position.x
        flyLeft.duration     = 5.0
//        flyLeft.repeatCount  = 2.5
//        flyLeft.autoreverses = true  // 反向动画
//        flyLeft.speed        = 2.0 // 虽然动画是5秒，但速度是双倍的
//        info.layer.speed     = 2.0 // 2倍 。总共是4倍的速度
        info.layer.add(flyLeft, forKey: "infoappear")
//        view.layer.speed     = 2.0
        let fadeLabelIn       = CABasicAnimation(keyPath: "opacity")  // opacity
        fadeLabelIn.fromValue = 0.2
        fadeLabelIn.toValue   = 1.0
        fadeLabelIn.duration  = 4.5
        info.layer.add(fadeLabelIn, forKey: "fadeIn")
        
        username.delegate = self
        password.delegate = self
        
        
        
        
        
    }
    
    // 按钮变色
    func tintBackgroundColor(_ layer:CALayer,toColor:UIColor) {
        let tint = CABasicAnimation(keyPath: "backgorundColor")
        tint.fromValue        = layer.backgroundColor
        tint.toValue          = toColor.cgColor
        tint.duration         = 5.0
        layer.add(tint, forKey: nil)
        layer.backgroundColor = toColor.cgColor
    }
    // 云动画
    func animateCloud(_ layer:CALayer) {
        // 计算速速
        // 1
        let cloudSpeed            = 60.0 / Double(self.view.layer.frame.size.width) // 60s
        let duration:TimeInterval = Double(view.layer.frame.size.width - view.layer.frame.origin.x) * cloudSpeed
        
        // 2
        let cloudMove      = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue  = self.view.bounds.size.width + layer.bounds.size.width / 2
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(layer, forKey: "layer")
        
        layer.add(cloudMove, forKey: nil)
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("动画已经结束！")
        if let name = anim.value(forKey: "name") as? String {
            // anim.value(forKey: "name") 返回是AnyObject类型 强制转换 String
            if name == "form"{
                let layer = anim.value(forKey: "layer") as? CALayer
                anim.setValue(nil, forKey: "layer") // 移除动画
                // 创建全新动画
//                let pulse = CABasicAnimation(keyPath: "transform.scale")
                let pulse       = CASpringAnimation(keyPath: "transform.scale")
                pulse.damping   = 7.5 // 添加阻尼
                pulse.fromValue = 1.25
                pulse.toValue   = 1.0
//                pulse.duration  = 0.25
                pulse.duration  = pulse.settlingDuration // 自己计算出动画的时间
                
                layer?.add(pulse, forKey: nil)
            }
            
            if name == "cloud"{
                if  let layer = anim.value(forKey: "layer") as? CALayer{
                    anim.setValue(nil, forKey: "layer") // 移除动画
                    // 让云动画重新开始
                    layer.position.x =   -layer.bounds.size.width / 2
                    let time: TimeInterval = 0.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
                        self.animateCloud(layer)
                    })
                }
            }
            
        }
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
//        let color = UIColor.red  //UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
//        self.tintBackgroundColor(self.loginButton.layer, toColor:color)
        
        //  课时 5 关键帧动画
        // 摇晃
        let wobble = CAKeyframeAnimation(keyPath: "transform.rotation")
        wobble.duration    = 0.25
        wobble.values      = [0.0,-Double.pi/16,0.0,Double.pi/16,0.0]
        wobble.keyTimes    = [0.0,0.25,0.5,0.75,1.0]
        wobble.repeatCount = 4
        self.headLabel.layer.add(wobble, forKey: nil)
        
        //气球 帧动画
        let balloon      = CALayer()
        balloon.contents = UIImage(named: "balloon")!.cgImage
        balloon.frame    = CGRect(x: -50.0, y: 0.0, width: 50.0, height: 65.0)
        self.view.layer.insertSublayer(balloon, below: username.layer)
        
        let flight = CAKeyframeAnimation(keyPath: "position")
        flight.duration = 12.0
        flight.values = [CGPoint(x:-50.0,y:0.0),
                         CGPoint(x:view.frame.size.width + 50,y:160.0),
                         CGPoint(x:-50.0,y:loginButton.center.y)].map{
                            NSValue(cgPoint:$0)}  // 用map 闭包
        flight.keyTimes = [0.0,0.5,1.0]
        balloon.add(flight, forKey: nil)
        balloon.position = CGPoint(x:-50.0,y:loginButton.center.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print(info.layer.animationKeys())
        info.layer.removeAnimation(forKey: "infoappear")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.count.hashValue)! < 5 {
            let jump       = CASpringAnimation(keyPath: "position.y")
            jump.fromValue = textField.layer.position.y + 1.0
            jump.toValue   = textField.layer.position.y
            jump.duration  = jump.settlingDuration
            jump.initialVelocity = 100 // 设置初始力 默认是0  + 越来越靠近平衡点，- 越来越远离平衡点
            jump.mass      = 10     // 质量
            jump.stiffness = 1500   // 质量太大的话 添加地球引力,默认100
            jump.damping   = 50     // but 动画时间有点长了，添加一下阻尼
            textField.layer.add(jump, forKey: nil)
        }
        
        // 边框震荡
        textField.layer.borderWidth = 3.0
        textField.layer.borderColor =  UIColor.clear.cgColor
        //            textField.borderStyle       = .roundedRect
        
        let flash       = CASpringAnimation(keyPath: #keyPath(CALayer.borderColor))
        flash.damping   = 25.0
        flash.stiffness = 200.0
        flash.fromValue = UIColor(red: 0.96, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
        flash.toValue   = UIColor.clear.cgColor
        flash.duration  = flash.settlingDuration
        textField.layer.add(flash, forKey: nil)
    }
}



