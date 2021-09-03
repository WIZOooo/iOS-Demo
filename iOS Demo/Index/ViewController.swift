//
//  ViewController.swift
//  iOS Demo
//
//  Created by iMac on 2021/9/3.
//

import UIKit

fileprivate let dataArray : NSArray = [IndexItemCellData(name: "Test", viewController: UIViewController.init())]

class ViewController: UIViewController {
    let cellReuseIdentifier = "IndexCell";
    
    private var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = _configTableView();
        self.view.addSubview(self.tableView!)
    }
    
    private func _configTableView() -> UITableView {
        let tableView : UITableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        tableView.register(IndexCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = dataArray[indexPath.row] as! IndexItemCellData
        let cell:IndexCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! IndexCell
        cell.configure(cellData: cellData)
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
