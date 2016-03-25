//
// CirCleView.swift
// GLCircleScrollVeiw
//
// Created by god、long on 15/7/3.
// Copyright (c) 2015年 ___GL___. All rights reserved.
//

import UIKit

let TimeInterval = 3.5 // 全局的时间间隔

class CirCleView: UIView, UIScrollViewDelegate {
    var contentScrollView: UIScrollView!
    var delegate: CirCleViewDelegate? {
        didSet {
            self.reloadData()
        }
    }
    var indexOfCurrentImage: Int! { // 当前显示的第几张图片
        // 监听显示的第几张图片，来更新分页指示器
        didSet {
            self.pageIndicator.currentPage = indexOfCurrentImage
        }
    }

    private var totalPageNumber: Int!
    var currentImageView: UIImageView!
    private var lastImageView: UIImageView!
    private var nextImageView: UIImageView!

    private var pageIndicator: UIPageControl! // 页数指示器

    private var timer: NSTimer? // 计时器

    // MARK:- Begin -
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.setUpCircleView(frame)
    }

    init(sizeOfImage: CGSize) {
        super.init(frame: CGRectZero)
        // 默认显示第一张图片
        self.indexOfCurrentImage = 0
        self.setUpCircleViewAutoLayout(sizeOfImage)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Privite Methods
    private func setUpCircleViewAutoLayout(sizeOfImage: CGSize) {
        if self.contentScrollView == nil {
            self.contentScrollView = UIScrollView()
            self.contentScrollView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.contentScrollView)
        }
        
        self.currentImageView = UIImageView()
        self.lastImageView = UIImageView()
        self.nextImageView = UIImageView()
        self.lastImageView.translatesAutoresizingMaskIntoConstraints = false
        self.currentImageView.translatesAutoresizingMaskIntoConstraints = false
        self.nextImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentScrollView.addSubview(self.lastImageView)
        self.contentScrollView.addSubview(self.currentImageView)
        self.contentScrollView.addSubview(self.nextImageView)

        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.pagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false

        // 添加点击事件
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(CirCleView.imageTapAction(_:)))
        currentImageView.addGestureRecognizer(imageTap)

        currentImageView.userInteractionEnabled = true
        currentImageView.clipsToBounds = true
        contentScrollView.addSubview(currentImageView)

        lastImageView.clipsToBounds = true
        contentScrollView.addSubview(lastImageView)

        nextImageView.clipsToBounds = true
        contentScrollView.addSubview(nextImageView)

        // 设置计时器
        self.timer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: #selector(CirCleView.timerAction), userInfo: nil, repeats: true)

        self.contentScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[last(width)][current(width)][next(width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["width": sizeOfImage.width], views: ["last": self.lastImageView, "current": self.currentImageView, "next": self.nextImageView]))
        self.contentScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[last(height)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["height": sizeOfImage.height], views: ["last": self.lastImageView, "current": self.currentImageView, "next": self.nextImageView]))
        self.contentScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[current(height)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["height": sizeOfImage.height], views: ["last": self.lastImageView, "current": self.currentImageView, "next": self.nextImageView]))
        self.contentScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[next(height)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["height": sizeOfImage.height], views: ["last": self.lastImageView, "current": self.currentImageView, "next": self.nextImageView]))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView": self.contentScrollView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView": self.contentScrollView]))
    }

    private func setUpCircleView(frame: CGRect) {
        if self.contentScrollView == nil {
            self.contentScrollView = UIScrollView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
            contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
            contentScrollView.delegate = self
            contentScrollView.bounces = false
            contentScrollView.pagingEnabled = true
            contentScrollView.showsHorizontalScrollIndicator = false
            contentScrollView.showsVerticalScrollIndicator = false
            self.addSubview(contentScrollView)
        }
        
        if self.currentImageView == nil {
            self.currentImageView = UIImageView()
            currentImageView.frame = CGRectMake(self.frame.size.width, 0, frame.size.width, frame.size.height)
            currentImageView.userInteractionEnabled = true
            currentImageView.clipsToBounds = true
            contentScrollView.addSubview(currentImageView)
            
            // 添加点击事件
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(CirCleView.imageTapAction(_:)))
            currentImageView.addGestureRecognizer(imageTap)
        }

        if self.lastImageView == nil {
            self.lastImageView = UIImageView()
            lastImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
            lastImageView.clipsToBounds = true
            contentScrollView.addSubview(lastImageView)
        }
        
        if self.nextImageView == nil {
            self.nextImageView = UIImageView()
            nextImageView.frame = CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height)
            nextImageView.clipsToBounds = true
            contentScrollView.addSubview(nextImageView)
        }

        // 设置计时器
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: #selector(CirCleView.timerAction), userInfo: nil, repeats: true)
    }

    // MARK:- 设置图片
    private func setScrollViewOfImage() {
        self.lastImageView.image = nil
        self.currentImageView.image = nil
        self.nextImageView.image = nil

        self.delegate?.refreshImageViewAtIndex(self.lastImageView, index: self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage))
        self.delegate?.refreshImageViewAtIndex(self.nextImageView, index: self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage))
        self.delegate?.refreshImageViewAtIndex(self.currentImageView, index: self.indexOfCurrentImage)
    }

    // 得到上一张图片的下标
    private func getLastImageIndex(indexOfCurrentImage index: Int) -> Int {
        let tempIndex = index - 1
        if tempIndex == -1 {
            if self.totalPageNumber > 0 {
                return self.totalPageNumber! - 1
            } else {
                print("图片轮播总数为0")
                return 0
            }
        } else {
            return tempIndex
        }
    }

    // 得到下一张图片的下标
    private func getNextImageIndex(indexOfCurrentImage index: Int) -> Int {
        let tempIndex = index + 1
        return tempIndex < self.totalPageNumber ? tempIndex : 0
    }

    // 事件触发方法
    func timerAction() {
        contentScrollView.setContentOffset(CGPointMake(self.frame.size.width * 2, 0), animated: true)
    }

    // MARK:-PublicMethods
    func showsPageIndicator(flag: Bool) {
        self.pageIndicator.hidden = !flag
    }

    func imageTapAction(tap: UITapGestureRecognizer) {
        self.delegate?.clickCurrentImage!(indexOfCurrentImage)
    }

    func reloadData() {
        self.setUpCircleView(self.bounds)

        self.totalPageNumber = (self.delegate?.numberOfImageViews())!
        if self.totalPageNumber < 2 {
            contentScrollView.scrollEnabled = false
            timer?.invalidate()
            timer = nil
        } else {
            contentScrollView.scrollEnabled = true
        }

        // 设置分页指示器
        let frame = CGRectMake(self.frame.size.width - 20 * CGFloat(self.totalPageNumber!), self.frame.size.height - 30, 20 * CGFloat(self.totalPageNumber!), 20)
        if self.pageIndicator != nil {
            self.pageIndicator.frame = frame
        } else {
            self.pageIndicator = UIPageControl(frame: frame)
            self.addSubview(pageIndicator)
        }
        pageIndicator.hidesForSinglePage = true
        pageIndicator.numberOfPages = self.totalPageNumber!
        pageIndicator.backgroundColor = UIColor.clearColor()

        self.setScrollViewOfImage()
        contentScrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
    }

    // MARK: - DelegateMethods
    // MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 如果用户手动拖动到了一个整数页的位置就不会发生滑动了所以需要判断手动调用滑动停止滑动方法
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        } else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(indexOfCurrentImage: self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        // 布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)

        // 重置计时器
        if timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: #selector(CirCleView.timerAction), userInfo: nil, repeats: true)
        }
    }

    // 时间触发器设置滑动时动画true，会触发的方法
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(contentScrollView)
    }
}

@objc protocol CirCleViewDelegate {
    /**
     *点击图片的代理方法
     *
     *@paraindex当前点击图片的下标
     */
    optional func clickCurrentImage(index: Int)

    /**
     加载图片的代理方法

     -parameterimageView:imageView暴露
     -parameterindex:位置Index
     */
    func refreshImageViewAtIndex(imageView: UIImageView, index: Int)

    /**
     图片张数

     -returns:图片张数
     */
    func numberOfImageViews() -> Int
}
