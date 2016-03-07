//
//  ViewController.swift
//  runcool
//
//  Created by David on 16/3/5.
//  Copyright (c) 2016年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var runner:UIImageView!
    
    var ground:[UIImageView!] = []
    
    var verWidth:CGFloat = 0.0
    var verHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  NSString(string: UIDevice.currentDevice().systemVersion).doubleValue < 8.0{
            verHeight = view.bounds.width
            verWidth = view.bounds.height
        }else{
            verWidth = view.bounds.width
            verHeight = view.bounds.height
        }
        // Do any additional setup after loading the view, typically from a nib.
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
        
        
        ground.append(UIImageView(frame: CGRectMake(0, verHeight-102, verWidth*1.5, 102)))
        ground[0].backgroundColor = UIColor.grayColor()
        view.addSubview(ground[0])
        
    }
    
    var gaming = false
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if gaming{
            runner.stopAnimating()
            jump = true
        }else{
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
    
    var jump = false
    var gravity:CGFloat = 0.0
    var top = false
    var score = 0
    
    
    func timer(sender:NSTimer){
        
        if gaming{
            for i in 0..<ground.count{
                if ground[ground.count-i-1].center.x + ground[ground.count-i-1].bounds.width > 0{
                    ground[ground.count-i-1].center.x -= 2
                }
            }
            
//            if Int(ground[score].center.x+ground[score].bounds.width/2)==Int(runner.center.x-35){
//                
//            }
            
            if ground[score].center.x+ground[score].bounds.width/2<runner.center.x-35{
                
                
                   var width = CGFloat(arc4random()%400+300)
                    var height = CGFloat(arc4random()%50+102)
                    ground.append(UIImageView(frame: CGRectMake(ground[score+1].center.x + ground[score+1].bounds.width/2 + 160, verHeight-height, width, height)))
                    ground[score+2].backgroundColor = UIColor.grayColor()
                    view.addSubview(ground[score+2])
                    score++
                    println(score)
                
                
                //
                if runner.center.y+50 >= ground[score-1].center.y - ground[score-1].bounds.height/2 && ground[score-1].center.x + ground[score-1].bounds.width/2 <= runner.center.x{
                    runner.stopAnimating()
                    UIView.animateWithDuration(0.5, animations: {
                        self.runner.center.y = self.verHeight + 50
                        self.runner.transform = CGAffineTransformMakeRotation(2)
                    })
                    gaming = false
                    
                }
//                else if ground[score+1].center.x - ground[score+1].bounds.width/2 <= runner.center.x && runner.center.y+50 >= ground[score+1].center.y - ground[score+1].bounds.height/2{
//                    
//                    
//                    println(score)
//                    
//                }
            }
            
        }
        
        if jump{
            
            if top{
                
                runner.center.y += gravity
                gravity+=0.1
                
                
                
                if runner.center.x+24 < ground[score].center.x-ground[score].bounds.width/2{
                    
                        if runner.center.y-50 >= verHeight{
                            gaming = false
                            jump = false
                            top = false
                            gravity = 0
                        }
                        
                }else{
                    
                    if runner.center.y + 50 >= ground[score].center.y - ground[score].bounds.height/2{
                        if runner.center.y + 50 <= ground[score].center.y - ground[score].bounds.height/2 + 5{
                            runner.startAnimating()
                            jump = false
                            top = false
                            gravity = 0
                            //println(score)
                        }else{
                        
                            gaming = false
                        
                        }
                        
                    
                    
                    }
                    
                    
                }
                
                
            }else{
                runner.center.y -= 4 - gravity
                gravity+=0.1
                if gravity >= 4{
                    gravity = 0
                    top = true
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
