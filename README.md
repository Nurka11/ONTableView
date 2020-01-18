# ONTableView

[![CI Status](https://img.shields.io/travis/Nurka11/ONTableView.svg?style=flat)](https://travis-ci.org/Nurka11/ONTableView)
[![Version](https://img.shields.io/cocoapods/v/ONTableView.svg?style=flat)](https://cocoapods.org/pods/ONTableView)
[![License](https://img.shields.io/cocoapods/l/ONTableView.svg?style=flat)](https://cocoapods.org/pods/ONTableView)
[![Platform](https://img.shields.io/cocoapods/p/ONTableView.svg?style=flat)](https://cocoapods.org/pods/ONTableView)

## Usage

```
import ONTableView

let tableView = ONTableView()

/// set refresh and load more delegates if you need
tableView.refreshManagerDelegate = self

tableView.loadMoreManagerDelegate = self
/// For load more manager you should implement UITableViewDelegate method // MUST
extension ViewController: UITableViewDelegate {
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? ONTableView {
            tableView.loadMoreControl?.didScroll(scrollView: scrollView)
        }
    }
    
}

extension ViewController: LoadMoreRefreshManagerDelegate, RefreshManagerDelegate {
    
    func loadMore() {
        // load more
    }
    
    func refresh() {
        // refresh
    }
    
}

```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ONTableView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ONTableView'
```

## Author

Nurka11, ormanali99@gmail.com

## License

ONTableView is available under the MIT license. See the LICENSE file for more info.
