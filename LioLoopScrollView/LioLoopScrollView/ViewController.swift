//
//  ViewController.swift
//  LioLoopScrollView
//
//  Created by Cocoa Lee on 16/1/12.
//  Copyright © 2016年 Cocoa Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController,LioLoopViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initLioView()
    }
    
    func initLioView (){
        let lioView = LioLoopView(frame: CGRectMake(0, 20, CGRectGetWidth(self.view.bounds),100))
        self.view.addSubview(lioView)
        lioView.delegate = self
        lioView.setLioScrollViewImageWithURLsArray(
            [
                "http://7xpsn4.com1.z0.glb.clouddn.com/1.jpg",
                "http://7xpsn4.com1.z0.glb.clouddn.com/2.png",
                "http://7xpsn4.com1.z0.glb.clouddn.com/3.jpg",
                "http://7xpsn4.com1.z0.glb.clouddn.com/4.png",
                "http://7xpsn4.com1.z0.glb.clouddn.com/5.png",
                "http://7xpsn4.com1.z0.glb.clouddn.com/6.png",
            ]
        )
    }
    
    func lioScrollViewClickAtIndex(index: NSInteger) {
        print("点击了第\(index)张")
        let alert = UIAlertController(title:nil, message: "点击了第\(index)张", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true) { () -> Void in
            dispatch_after(1, dispatch_get_main_queue(), { () -> Void in
                alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            })
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

