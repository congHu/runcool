//
//  ViewController.swift
//  runcool
//
//  Created by David on 16/3/5.
//  Copyright (c) 2016年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    var runner:UIImageView!
    
    var ground:[UIImageView!] = []
    
    var verWidth:CGFloat = 0.0
    var verHeight:CGFloat = 0.0
    
    @IBOutlet var RestartBtn: UIButton!
    @IBOutlet var scoreBoard: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //版本检测 ios7和ios8的宽高反转
        if  NSString(string: UIDevice.currentDevice().systemVersion).doubleValue < 8.0{
            verHeight = view.bounds.width
            verWidth = view.bounds.height
        }else{
            verWidth = view.bounds.width
            verHeight = view.bounds.height
        }
        
        //跑步动画 构造
        runner = UIImageView(frame: CGRectMake(100, verHeight - 200, 70, 100))
        var animateImg:[UIImage] = []
        for i in 0...9{
            animateImg.append(UIImage(named: "runner_\(i)")!)
        }
        view.addSubview(runner)
        runner.image = UIImage(named: "runner_1")
        runner.animationImages = animateImg
        runner.animationDuration = 0.6
        runner.animationRepeatCount = 0
        
//        runner.startAnimating()
        
        
        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "timer:", userInfo: nil, repeats: true)
        
        //地面 构造
        ground.append(UIImageView(frame: CGRectMake(0, verHeight-102, verWidth*1.5, 102)))
        ground[0].backgroundColor = UIColor.grayColor()
        view.addSubview(ground[0])
        
        RestartBtn.alpha = 0
        
    }
    
    var gaming = false
    var gameOvering = false
    
    var touching = false
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if gaming{
            touching = true
            runner.stopAnimating()
            jump = true
        }else{
            if !gameOvering{
                runner.image = UIImage(named: "runner_4")
                runner.startAnimating()
            
                gaming = true
                var width = CGFloat(arc4random()%400+300)
                var height = CGFloat(arc4random()%50+102)
                ground.append(UIImageView(frame: CGRectMake(ground[0].bounds.width+160, verHeight-height, width, height)))
                ground[1].backgroundColor = UIColor.grayColor()
                view.addSubview(ground[1])
            }
            
        }
        
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        touching = false
    }
    
    var jump = false
    var gravity:CGFloat = 0.0
    var top = false
    var score = 0
    var showScore = 0
    
    var jumpHeight:CGFloat = 1.0
    
    func timer(sender:NSTimer){
        
        if gaming{
            
            //地面移动
            for i in 0..<ground.count{
                if ground[ground.count-i-1].center.x + ground[ground.count-i-1].bounds.width > 0{
                    ground[ground.count-i-1].center.x -= 2
                }
            }
            
            
            showScore++
            scoreBoard.text = "\(showScore)"

            //判断到了边缘 准备跳
            if ground[score].center.x+ground[score].bounds.width/2<runner.center.x-35{
                
                //新建一个地面
                var width = CGFloat(arc4random()%400+300)
                var height = CGFloat(arc4random()%50+102)
                ground.append(UIImageView(frame: CGRectMake(ground[score+1].center.x + ground[score+1].bounds.width/2 + 160, verHeight-height, width, height)))
                ground[score+2].backgroundColor = UIColor.grayColor()
                view.addSubview(ground[score+2])
                score++
                println(score)
                
                
                //到了边缘还不跳就死了
                if runner.center.y+50 >= ground[score-1].center.y - ground[score-1].bounds.height/2 && ground[score-1].center.x + ground[score-1].bounds.width/2 <= runner.center.x{
                    runner.stopAnimating()
                    UIView.animateWithDuration(0.5, animations: {
                        self.runner.center.y = self.verHeight + 50
                        self.runner.transform = CGAffineTransformMakeRotation(2)
                    })
                    gaming = false
                    RestartBtn.alpha = 1
                    gameOvering = true
                    
                }

            }
            
        }
        
        if jump{
            
            if top{
                
                runner.center.y += gravity
                gravity+=0.1
                
                
                //判断是否边缘跳 否则是普通跳跃
                if runner.center.x+24 < ground[score].center.x-ground[score].bounds.width/2{
                    
                    //跳不过 掉下去
                    if runner.center.y-50 >= verHeight{
                        gaming = false
                        RestartBtn.alpha = 1
                        jump = false
                        top = false
                        gravity = 0
                        UIView.animateWithDuration(0.5, animations: {
                            self.runner.transform = CGAffineTransformMakeRotation(-2)
                        })
                        gameOvering = true
                    }
                        
                }else{
                    
                    //普通跳跃
                    if runner.center.y + 50 >= ground[score].center.y - ground[score].bounds.height/2{
                        if runner.center.y + 50 <= ground[score].center.y - ground[score].bounds.height/2 + 5{
                            runner.startAnimating()
                            jump = false
                            top = false
                            gravity = 0
                            //println(score)
                        }else{
                            
                            //还是跳不过
                            gaming = false
                            RestartBtn.alpha = 1
                            UIView.animateWithDuration(0.5, animations: {
                                self.runner.transform = CGAffineTransformMakeRotation(-2)
                            })
                            gameOvering = true
                        
                        }
                        
                    
                    
                    }
                    
                    
                }
                
                
            }else{
                //正在往上跳
                if touching{
                    jumpHeight += 0.2
                }
                runner.center.y -= jumpHeight - gravity
                gravity+=0.1
                if jumpHeight >= 5.0{
                    touching = false
                }
                if gravity >= jumpHeight{
                    gravity = 0
                    top = true
                    jumpHeight = 1.0
                }
            }
        }
    }
    
    
    
    @IBAction func restart(sender: UIButton) {
        RestartBtn.alpha = 0
        
        jump = false
        top = false
        gravity = 0
        score = 0
        showScore = 0
        scoreBoard.text = "\(showScore)"
        gameOvering = false
        
        for i in ground{
            i.alpha = 0
        }
        ground.removeAll()
        ground.append(UIImageView(frame: CGRectMake(0, verHeight-102, verWidth*1.5, 102)))
        ground[0].backgroundColor = UIColor.grayColor()
        view.addSubview(ground[0])
        
        runner.image = UIImage(named: "runner_1")
        runner.stopAnimating()
        runner.center = CGPointMake(135, verHeight-152)
        runner.transform = CGAffineTransformMakeRotation(0)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

