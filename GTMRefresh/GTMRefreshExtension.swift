//
//  GTMRefreshExtension.swift
//  GTMRefresh
//
//  Created by luoyang on 2016/12/7.
//  Copyright © 2016年 luoyang. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIScrollView {
    
    private var gtmHeader: GTMRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmHeader) as? GTMRefreshHeader
        }
        set {
           objc_setAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var gtmFooter: GTMLoadMoreFooter? {
        get {
            return objc_getAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmFooter) as? GTMLoadMoreFooter
        }
        set {
            objc_setAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 添加下拉刷新
    ///
    /// - Parameters:
    ///   - refreshHeader: 下拉刷新动效View必须继承GTMRefreshHeader并且要实现SubGTMRefreshHeaderProtocol，不传值的时候默认使用 DefaultGTMRefreshHeader
    ///   - refreshBlock: 刷新数据Block
    public func gtm_addRefreshHeaderView(refreshHeader: GTMRefreshHeader? = DefaultGTMRefreshHeader(), refreshBlock:@escaping () -> Void) {
        guard refreshHeader is SubGTMRefreshHeaderProtocol  else {
            fatalError("refreshHeader must implement SubGTMRefreshHeaderProtocol")
        }
        if let header: GTMRefreshHeader = refreshHeader, let subProtocol = header.subProtocol {
            header.frame = CGRect(x: 0, y: 0, width: self.mj_w, height: subProtocol.contentHeith())
        }
        if gtmHeader != refreshHeader {
            gtmHeader?.removeFromSuperview()
            
            if let header:GTMRefreshHeader = refreshHeader {
                header.refreshBlock = refreshBlock
                self.insertSubview(header, at: 0)
                self.gtmHeader = header
            }
        }
    }
    
    /// 添加上拉加载
    ///
    /// - Parameters:
    ///   - loadMoreFooter: 上拉加载动效View必须继承GTMLoadMoreFooter，不传值的时候默认使用 DefaultGTMLoadMoreFooter
    ///   - refreshBlock: 加载更多数据Block
    public func gtm_addLoadMoreFooterView(loadMoreFooter: GTMLoadMoreFooter? = DefaultGTMLoadMoreFooter(), loadMoreBlock:@escaping () -> Void) {
        
        guard loadMoreFooter is SubGTMLoadMoreFooterProtocol  else {
            fatalError("loadMoreFooter must implement SubGTMLoadMoreFooterProtocol")
        }
        if let footer: GTMLoadMoreFooter = loadMoreFooter, let subProtocol = footer.subProtocol {
            footer.frame = CGRect(x: 0, y: 0, width: self.mj_w, height: subProtocol.contentHeith())
        }
        
        if gtmFooter != loadMoreFooter {
            gtmFooter?.removeFromSuperview()
            
            if let footer:GTMLoadMoreFooter = loadMoreFooter {
                footer.loadMoreBlock = loadMoreBlock
                self.insertSubview(footer, at: 0)
                self.gtmFooter = footer
            }
        }
    }
    
    public func endRefreshing(isSuccess: Bool) {
        self.gtmHeader?.endRefresing(isSuccess: isSuccess)
        if isSuccess {
            // 重置footer状态（防止footer还处在数据加载完成状态）
            self.gtmFooter?.state = .idle
        }
    }
    public func endLoadMore(isNoMoreData: Bool) {
        self.gtmFooter?.endLoadMore(isNoMoreData: isNoMoreData)
    }
}

extension UIScrollView {
    var mj_insetT: CGFloat {
        get { return contentInset.top }
        set {
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
    }
    var mj_insetB: CGFloat {
        get { return contentInset.bottom }
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
    }
    var mj_insetL: CGFloat {
        get { return contentInset.left }
        set {
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
    }
    var mj_insetR: CGFloat {
        get { return contentInset.right }
        set {
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
        }
    }
    
    
    var mj_offsetX: CGFloat {
        get { return contentOffset.x }
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
    }
    var mj_offsetY: CGFloat {
        get { return contentOffset.y }
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    
    
    var mj_contentW: CGFloat {
        get { return contentSize.width }
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
    }
    var mj_contentH: CGFloat {
        get { return contentSize.height }
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
    }
}

extension UIView {
    
    var mj_x: CGFloat {
        get { return frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var mj_y: CGFloat {
        get { return frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var mj_w: CGFloat {
        get { return frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var mj_h: CGFloat {
        get { return frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var mj_size: CGSize {
        get { return frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var mj_origin: CGPoint {
        get { return frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var mj_center: CGPoint {
        get { return CGPoint(x: (frame.size.width-frame.origin.x)*0.5, y: (frame.size.height-frame.origin.y)*0.5) }
        set {
            var frame = self.frame
            frame.origin = CGPoint(x: newValue.x - frame.size.width*0.5, y: newValue.y - frame.size.height*0.5)
            self.frame = frame
        }
    }
    
}