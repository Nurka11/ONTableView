//
//  ONTableView.swift
//  ONTableView
//
//  Created by NURZHAN ORMANALI.
//

import UIKit

public protocol LoadMoreRefreshManagerDelegate: class {
    func loadMore()
}

public protocol RefreshManagerDelegate: class {
    func refresh()
}

private protocol LoadMoreAnimationDelegate: class {
    func startAnimating()
}

public class ONTableView: UITableView {
    
    public var loadMoreControl: LoadMoreManager?
    
    lazy var topRefreshController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    lazy var bottomView: UIView = {
        let infiniteScrollingView = UIView(frame: CGRect(x: 0, y: self.contentSize.height, width: self.bounds.size.width, height: 60))
        infiniteScrollingView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityViewIndicator.frame = CGRect(x: infiniteScrollingView.frame.size.width / 2 - activityViewIndicator.frame.width / 2, y: infiniteScrollingView.frame.size.height / 2 - activityViewIndicator.frame.height / 2, width: activityViewIndicator.frame.width, height: activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        infiniteScrollingView.addSubview(activityViewIndicator)
        
        return infiniteScrollingView
    }()
    
    public lazy var loadMoreManager: LoadMoreManager = {
        let manager = LoadMoreManager()
        
        return manager
    }()
    
    public weak var loadMoreManagerDelegate: LoadMoreRefreshManagerDelegate? {
        didSet {
            if let _ = self.loadMoreManagerDelegate {
                self.loadMoreManager.delegate = self
            } else {
                self.loadMoreManager.delegate = nil
            }
            self.loadMoreControl = self.loadMoreManager
        }
    }
    
    public weak var refreshManagerDelegate: RefreshManagerDelegate? {
        didSet {
            if let _ = self.refreshManagerDelegate {
                self.refreshControl = self.topRefreshController
            } else {
                self.refreshControl = nil
            }
        }
    }
    
    fileprivate func settings() { // This settings for preventing automatic height on ios 10
        estimatedRowHeight = 44
        rowHeight = UITableViewAutomaticDimension
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        settings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func endRefreshingTable(loadMoreStatus: Bool = false) {
        self.topRefreshController.endRefreshing()
        self.tableFooterView = UIView(frame: .zero)
        self.loadMoreManager.loadMoreStatus = loadMoreStatus
    }
    
    @objc private func refreshTableView(_ sender: UIRefreshControl) {
        self.refreshManagerDelegate?.refresh()
    }
    
//    public func displayHideEmptyPlaceholder(with type: PlaceholderType) {
//        if totalNumberOfRows != 0 {
//            backgroundView = nil
//        } else {
//            let emptyPlaceholderView = EmptyPlaceholderView(type: type)
//            backgroundView = emptyPlaceholderView
//        }
//    }
    
}

extension ONTableView: LoadMoreAnimationDelegate {
    
    public func startAnimating() {
        if totalNumberOfRows > 0 {
            self.tableFooterView = bottomView
            self.loadMoreManagerDelegate?.loadMore()
        }
    }
    
}

public class LoadMoreManager {
    
    fileprivate var delegate: LoadMoreAnimationDelegate?
    
    var loadMoreStatus = false
    
    init() {}
    
    public func didScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset <= 20 {
            loadMore()
        }
    }
    
    func loadMore() {
        if ( !loadMoreStatus ) {
            self.loadMoreStatus = true
            delegate?.startAnimating()
        }
    }
    
}


public extension UITableView {
    var totalNumberOfRows: Int {
        var totalNumber = 0
        for section in 0 ..< numberOfSections {
            for _ in 0 ..< numberOfRows(inSection: section) {
                totalNumber += 1
            }
        }
        
        return totalNumber
    }
}
