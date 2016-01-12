//
//  LioLoopView.swift
//  LioLoopScrollView
//
//  Created by Cocoa Lee on 16/1/12.
//  Copyright © 2016年 Cocoa Lee. All rights reserved.
//

import UIKit

class LioLoopView: UIView,UIScrollViewDelegate{

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let lioScrollView = UIScrollView()
    var delegate = LioLoopViewDelegate?()
    var urlsArray = NSMutableArray()
    var timer = NSTimer()
    var pageControl = UIPageControl()
    
    
    //记录偏移量
    var contentOffsetX = CGFloat(0.0)
    //方向枚举值
    enum SlidingDirection {
        case  fromLeftToRight     //视图向右边滑动
        case  fromRightToLeft     //视图向左边滑动
    }
    var direction:(SlidingDirection) = SlidingDirection.fromLeftToRight
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.initialize()
    
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    func initialize() {
        NSLog("common init")
        self.lioScrollView.frame = self.bounds
        self.lioScrollView.pagingEnabled = true
        self.lioScrollView.delegate = self
        self.lioScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.lioScrollView)
        self.resetScrollViewContentOffset()
        self.lioScrollView.bounces = false
        
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 250/255.0, green: 99/255.0, blue: 175/255.0, alpha: 1)
        self.timerStart()
        
        
        self.pageControl.frame = CGRectMake(self.frame.width - 100, self.frame.height - 20, 100, 20)
        self.addSubview(pageControl)
    }
    
    /**
     设置View大小
     
     - parameter fram: fram
     */
    func setLioViewFram(fram:CGRect) {
        self.frame = frame;
    }
    
    /**
     设置滚动视图的arrays
     
     - parameter viewsArray: viewsArray
     */
    func setLioScrollViewImageWithURLsArray(URLsArray:NSArray) {
        self.pageControl.numberOfPages = URLsArray.count
        self.pageControl.currentPage = 0
        if URLsArray.count == 0 {
            print("没有图片传入")
            return
        }
        else if URLsArray.count == 1 {
            self.urlsArray.addObjectsFromArray(URLsArray as [AnyObject]);
            timerStop()
        }
        else {
            self.urlsArray.addObjectsFromArray(URLsArray as [AnyObject])
            self.urlsArray.insertObject(URLsArray[URLsArray.count-1], atIndex: 0)
            self.urlsArray.insertObject(URLsArray[0], atIndex: self.urlsArray.count)
        }
  
        if urlsArray.count > 0 {
            let viewsCount = self.urlsArray.count
            let contentWidth = self.lioScrollView.frame.width * CGFloat(viewsCount)
            self.lioScrollView.contentSize = CGSizeMake(contentWidth, self.lioScrollView.frame.height)
            self.addImageToLioScrollView(self.urlsArray)
            self.contentOffsetX = self.lioScrollView.contentOffset.x;
        }
        else {
            print("没有添加图片")
        }
    }
    
    /**
     添加图片
     
     - parameter URLsArray: URLsArray
     */
    func addImageToLioScrollView(urlArray:NSArray) {
      
        //第一步 把所有图片添加到 ScrollView 上
        for index in 0..<urlArray.count {
            
            let  urlString = urlArray[index] as! (String)
            let imageButton = UIButton()
            let url = NSURL(string: urlString)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let image = UIImage(data: NSData(contentsOfURL: url!)!)
                dispatch_async(dispatch_get_main_queue(), {
                    imageButton.setImage(image, forState: UIControlState.Normal)
                })
            })
            self.lioScrollView.backgroundColor = UIColor.grayColor()
            imageButton.frame = CGRectMake(CGFloat(index) * self.lioScrollView.frame.width, 0, self.lioScrollView.frame.width, self.lioScrollView.frame.height)
            imageButton.tag = index
            imageButton.addTarget(self, action: "imageButtonEvent:", forControlEvents: UIControlEvents.TouchUpInside)
            self.lioScrollView.addSubview(imageButton)
        }
        
        
    }
    
    
    //重置偏移量
    func resetScrollViewContentOffset (){
        switch  self.direction {
        case SlidingDirection.fromLeftToRight:
            self.contentOffsetX = self.lioScrollView.frame.width;
            self.lioScrollView.contentOffset = CGPointMake(self.lioScrollView.frame.width, 0);

        case SlidingDirection.fromRightToLeft:
            let count = self.urlsArray.count - 2;
            self.contentOffsetX = self.lioScrollView.frame.width * CGFloat(count);
            self.lioScrollView.contentOffset = CGPointMake(self.lioScrollView.frame.width * CGFloat(count), 0);
        }
    }
    

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x - self.contentOffsetX ) > 0 {
            self.direction = SlidingDirection.fromLeftToRight
        } else  if (scrollView.contentOffset.x - self.contentOffsetX ) < 0{
            self.direction = SlidingDirection.fromRightToLeft
        }else {
            
        }
        self.contentOffsetX = scrollView.contentOffset.x;
        self.setPageControlWithScrollView(scrollView)

    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
         self.timerStop()
        let  contentOffsetX = scrollView.contentOffset.x
        switch self.direction {
        case SlidingDirection.fromLeftToRight:
            let realLastWidth =  scrollView.contentSize.width - scrollView.frame.width ;
            if contentOffsetX > realLastWidth || contentOffsetX == realLastWidth {
                self .resetScrollViewContentOffset()
            }
        case SlidingDirection.fromRightToLeft:
            let realLastWidth = CGFloat(0);
            if contentOffsetX < realLastWidth || contentOffsetX == realLastWidth {
                self .resetScrollViewContentOffset()
            }
        }
    }
 
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
       self.timerStart()
    }
    

    func setPageControlWithScrollView(scrollView:UIScrollView) {
        
       var currenIndex = NSInteger(scrollView.contentOffset.x/scrollView.frame.width)
        if currenIndex == self.urlsArray.count - 1 {
            currenIndex = 0
        }
       self.pageControl.currentPage = NSInteger(currenIndex-1)
    }
    
    
    func timerStart (){
       self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "timerEvent", userInfo: nil, repeats: true)
    }
    
    
    func timerStop () {
        self.timer.invalidate()
    }
    
    
    func timerEvent (){
            if (self.lioScrollView.contentOffset.x > self.lioScrollView.contentSize.width - self.lioScrollView.frame.width * 2) {
                self.lioScrollView.contentOffset = CGPointMake(self.lioScrollView.frame.width, 0)
            }
            UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.lioScrollView.contentOffset = CGPointMake(self.lioScrollView.contentOffset.x + self.lioScrollView.frame.width, 0)
            })

           self.setPageControlWithScrollView(self.lioScrollView)
    }
    
    
    func imageButtonEvent(imageButton:UIButton){
        var indexOfImage = NSInteger()
        if imageButton.tag == self.urlsArray.count - 1 {
            indexOfImage = 1
        }
        else if imageButton.tag == 0 {
            indexOfImage = self.urlsArray.count - 1
        }
        else {
            indexOfImage = imageButton.tag
        }
        
        self.delegate?.lioScrollViewClickAtIndex(indexOfImage)
    }
    
}


protocol LioLoopViewDelegate {
    /**
     代理方法
     
     - parameter index: 从1到图片的总数
     */
   func lioScrollViewClickAtIndex(index:NSInteger)
    
}
