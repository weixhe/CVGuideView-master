//
//  CVParallaxGuideView.swift
//  CVGuideView
//
//  Created by caven on 2018/10/11.
//  Copyright © 2018 com.caven. All rights reserved.
//

import UIKit

enum CVScrollDirection : Int {
    case vertical
    case horizontal
}

/// 视差引导页
class CVParallaxGuideView: UIView {
    /* 公有属性 */
    var backgroundImage: UIImage?
    var titles: [String]?
    var contents: [String]?
    var scrollDirection: CVScrollDirection = .horizontal    // 这里的滑动方向指的是手指滑动方向和文本移动方向，不包含图片的移动方向
    var dragToHiden: Bool = true
    
    /* 私有属性 */
    private var backgroundImageView: UIImageView!
    private var titleScroll: UIScrollView!
    private var contentScroll: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.titleScroll = UIScrollView(frame: self.bounds)
        self.titleScroll.delegate = self
        self.titleScroll.isPagingEnabled = true
        
        self.contentScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.bounds.width + 200, height: self.bounds.height))
        self.contentScroll.isPagingEnabled = true
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.contentScroll)
        self.addSubview(self.titleScroll)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        if let image = self.backgroundImage {
            var width: CGFloat = 0
            var height: CGFloat = 0
            if image.size.width > image.size.height {       // 图片横向滑动
                width = image.size.width / image.size.height * self.frame.height
                height = self.frame.height
            } else {        // 图片竖向滑动
                width = self.frame.width
                height = width / (image.size.width / image.size.height)
            }
            self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.backgroundImageView.image = image
        }
        
        var titleData: [String] = []
        var contentData: [String] = []
        
        if let titles = self.titles { titleData = titles }
        if let contents = self.contents { contentData = contents }
        
        let pages = max(titleData.count, contentData.count)
        
        if self.scrollDirection == .horizontal {
            self.titleScroll.frame = self.bounds
            self.titleScroll.contentSize = CGSize(width: self.frame.width * CGFloat(pages), height: self.frame.height)
            self.contentScroll.frame = CGRect(x: 0, y: 0, width: self.bounds.width + 200, height: self.bounds.height)
            self.contentScroll.contentSize = CGSize(width: self.frame.width * CGFloat(pages), height: self.frame.height)
        } else if self.scrollDirection == .vertical {
            self.titleScroll.frame = self.bounds
            self.titleScroll.contentSize = CGSize(width: self.frame.width, height: self.frame.height * CGFloat(pages))
            self.contentScroll.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 200)
            self.contentScroll.contentSize = CGSize(width: self.frame.width, height: self.frame.height * CGFloat(pages))
        }
        
        var titleX: CGFloat = 0.0
        var titleY: CGFloat = 0.0
        var contentX: CGFloat = 0.0
        var contentY: CGFloat = 0.0
        
        for i in 0..<pages {
            
            let title = titleData.count > i ? titleData[i] : ""
            let content = contentData.count > i ? contentData[i] : ""
            
            let titleLabel = self.createTitleLabel(text: title)
            let titleHeight = TextHeight(title, font: titleLabel.font, fixedWidth: self.titleScroll.frame.width - 20)
            titleLabel.frame = CGRect(x: titleX + 15, y: titleY + 50, width: self.titleScroll.frame.width - 20, height: titleHeight)
            
            let maxHeight = self.titleScroll.frame.height - titleHeight - 50 - 100.0
            let contentLabel = self.createContentLabel(text: content)
            var contentHeight = TextHeight(content, font: contentLabel.font, fixedWidth: self.titleScroll.frame.width - 20)
            if contentHeight > maxHeight { contentHeight = maxHeight }
            
            
            if self.scrollDirection == .horizontal {
                
                contentY = titleLabel.frame.maxY + 10.0
                contentLabel.frame = CGRect(x: contentX + 15, y: contentY, width: self.titleScroll.frame.width - 20, height: contentHeight)
                
                titleX = self.titleScroll.frame.width * CGFloat(i + 1)
                contentX = self.contentScroll.frame.width * CGFloat(i + 1)
                
            } else if self.scrollDirection == .vertical {
                contentY += titleHeight + 50 + 10
                contentLabel.frame = CGRect(x: contentX + 15, y: contentY, width: self.titleScroll.frame.width - 20, height: contentHeight)
                
                titleY = self.titleScroll.frame.height * CGFloat(i + 1)
                contentY = self.contentScroll.frame.height * CGFloat(i + 1)
            }
        }
    }
}

// MARK: - 公有方法
extension CVParallaxGuideView {
    
    convenience init(titles: [String]?, contents: [String]?, backgroundImage: UIImage?) {
        self.init()
        self.titles = titles
        self.contents = contents
        self.backgroundImage = backgroundImage
    }
    
    /// 显示到view视图上
    func show(in view: UIView, frame: CGRect = UIScreen.main.bounds, scrollDirection: CVScrollDirection = .horizontal) {
        self.frame = frame
        self.scrollDirection = scrollDirection
        view.addSubview(self)
    }
}

// MARK: - 私有方法
private extension CVParallaxGuideView {
    func createTitleLabel(text: String) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont(name: "Georgia", size: 32)
        label.text = text
        label.textColor = UIColor.white
        label.numberOfLines = 0
        self.titleScroll.addSubview(label)
        return label
    }
    
    func createContentLabel(text: String) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.text = text
        label.textColor = UIColor.init(white: 0.8, alpha: 0.9)
        label.numberOfLines = 0
        self.contentScroll.addSubview(label)
        return label
    }
}

// MARK: - UIScrollViewDelegate 代理
extension CVParallaxGuideView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.titleScroll {
            
            if self.scrollDirection == .horizontal {
                let contentX: CGFloat = self.titleScroll.contentOffset.x / self.titleScroll.frame.width * self.contentScroll.frame.width;
                self.contentScroll.contentOffset = CGPoint(x: contentX, y: 0.0)
                if let image = self.backgroundImage {
                    if image.size.width > image.size.height {       // 图片是横向的
                        var transX: CGFloat = self.titleScroll.contentOffset.x / (self.titleScroll.contentSize.width - self.titleScroll.frame.width) * (self.backgroundImageView.frame.width - self.frame.width);
                        transX = max(0.0, transX)
                        transX = min(self.backgroundImageView.frame.width - self.frame.width, transX);
                        self.backgroundImageView.transform = CGAffineTransform(translationX: -transX, y: 0.0)
                    } else {    // 图片时竖向的
                        var transY: CGFloat = self.titleScroll.contentOffset.x / (self.titleScroll.contentSize.width - self.titleScroll.frame.width) * (self.backgroundImageView.frame.height - self.frame.height);
                        transY = max(0.0, transY)
                        transY = min(self.backgroundImageView.frame.height - self.frame.height, transY);
                        self.backgroundImageView.transform = CGAffineTransform(translationX: 0.0, y: -transY)
                    }
                }
                
            } else if self.scrollDirection == .vertical {
                let contentY: CGFloat = self.titleScroll.contentOffset.y / self.titleScroll.frame.height * self.contentScroll.frame.height;
                self.contentScroll.contentOffset = CGPoint(x: 0.0, y: contentY)
                if let image = self.backgroundImage {
                    if image.size.width > image.size.height {       // 图片是横向的
                        var transX: CGFloat = self.titleScroll.contentOffset.y / (self.titleScroll.contentSize.height - self.titleScroll.frame.height) * (self.backgroundImageView.frame.width - self.frame.width);
                        transX = max(0.0, transX)
                        transX = min(self.backgroundImageView.frame.width - self.frame.width, transX);
                        self.backgroundImageView.transform = CGAffineTransform(translationX: -transX, y: 0.0)
                    } else {    // 图片时竖向的
                        var transY: CGFloat = self.titleScroll.contentOffset.y / (self.titleScroll.contentSize.height - self.titleScroll.frame.height) * (self.backgroundImageView.frame.height - self.frame.height);
                        transY = max(0.0, transY)
                        transY = min(self.backgroundImageView.frame.height - self.frame.height, transY);
                        self.backgroundImageView.transform = CGAffineTransform(translationX: 0.0, y: -transY)
                    }
                }
            }
            
        } else {

        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.titleScroll {
            if self.dragToHiden {

                if scrollView.contentOffset.x + scrollView.frame.width > scrollView.contentSize.width + 20 ||
                    scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 20 {
                    UIView.animate(withDuration: 1.5, animations: {
                        self.alpha = 0
                    }) { (_) in
                        self.removeFromSuperview()
                    }
                }
            }
        }
    }
}

func TextHeight(_ text: String, font: UIFont, fixedWidth: CGFloat) -> CGFloat {
    guard text.count > 0 && fixedWidth > 0 else { return 0 }
    let size = CGSize(width: fixedWidth, height: 9999)
    let rect = (text as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil)
    return rect.size.height
}
