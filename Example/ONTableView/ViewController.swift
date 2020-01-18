//
//  ViewController.swift
//  ONTableView
//
//  Created by Nurka11 on 01/18/2020.
//  Copyright (c) 2020 Nurka11. All rights reserved.
//

import UIKit

import ONTableView

class ViewController: UIViewController {
    
    let tableView = ONTableView()
    
    var data: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    var page: Int = 1
    
    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        delegating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func delegating() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.loadMoreManagerDelegate = self
        tableView.refreshManagerDelegate = self
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(data[indexPath.row]) cell"
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let tableView = scrollView as? ONTableView {
            tableView.loadMoreControl?.didScroll(scrollView: scrollView)
        }
    }
    
}

extension ViewController: LoadMoreRefreshManagerDelegate, RefreshManagerDelegate {
    
    func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.page += 1
            let newData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map({ $0 + ((self.page - 1) * 10) })
            self.data.append(contentsOf: newData)
            self.tableView.reloadData()
            self.tableView.endRefreshingTable(loadMoreStatus: self.page == 4)
        }
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.page = 1
            self.data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            self.tableView.reloadData()
            self.tableView.endRefreshingTable()
        }
    }
    
}

