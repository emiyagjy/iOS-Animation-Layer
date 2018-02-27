//
//  ViewController.swift
//  ShapeSqueezingAnimation
//
//  Created by GujyHy on 2018/1/10.
//  Copyright © 2018年 GujyHy. All rights reserved.
//


import UIKit
func delay(_ seconds:Double,completion:@escaping ()->()){
    let dispatchTime = DispatchTime.now() + seconds
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        completion()
    })
}
class ViewController: UIViewController {

    @IBOutlet var myAvatar: AvatarView!
    @IBOutlet var opponetnAvatar: AvatarView!
    
    @IBOutlet var vs: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var searchAgain: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 游戏开始时 搜索对手的动画
        searchForOpponent()
        
    }
    
    
    func searchForOpponent(){
        let avatarSize    = self.myAvatar.frame.size
        let bounceXOffset: CGFloat = avatarSize.width/1.9 // 碰撞后左右偏移量
        let morphSize     = CGSize(width: avatarSize.width * 0.90,
                                   height: avatarSize.height * 1.0)
        
   
        let rightBouncePoint = CGPoint(x: view.frame.size.width / 2 + bounceXOffset,
                                       y: self.myAvatar.center.y)
        let leftBouncePoint  = CGPoint(x: view.frame.size.width / 2 - bounceXOffset,
                                       y: self.myAvatar.center.y)
        // 添加碰撞后的反弹动画
        self.myAvatar.bounceOffPoint(bouncePoint: rightBouncePoint, morphSize: morphSize) // 在右侧这个点发生形状变形
        self.opponetnAvatar.bounceOffPoint(bouncePoint: leftBouncePoint, morphSize: morphSize) // 在左侧这个点发生形状变形
        
        // 再 模拟找到对手状态的动画
        delay(4.0, completion: foundOpponent)
        
    }
    // 寻找对象
    func foundOpponent(){
        self.status.text          = "Connecting ... "
        self.opponetnAvatar.image = UIImage(named:"avatar-2")
        self.opponetnAvatar.name  = "Ray"
        
        delay(4.0, completion: connectedToOpponent)
    }
    // 与对手进行连接
    func connectedToOpponent(){
        
        // 结束碰撞动画 椭圆形图层 ->  正方向
        self.myAvatar.shouldTransitonFinishedState = true
        self.opponetnAvatar.shouldTransitonFinishedState = true
        
        delay(1.0, completion: readyToPlay)
        
    }
    // 准备开始游戏
    func readyToPlay(){
        UIView.animate(withDuration: 0.2, animations: {
            self.vs.alpha = 1.0
            self.searchAgain.alpha = 1.0
        })
    }
    
}

