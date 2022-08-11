//
//  ViewController.swift
//  iOS Demo
//
//  Created by iMac on 2021/9/3.
//

import UIKit

fileprivate let dataArray : [IndexItemCellData] = [
    IndexItemCellData(name: "self和super", viewController: SelfSuperViewController.init()),
    IndexItemCellData(name: "PlaygroundOC", viewController: PlaygroundOCViewController.init()),
    IndexItemCellData(name: "PlaygroundSwift", viewController: PlaygroundSwiftViewController.init()),
    IndexItemCellData(name: "静态类型与动态类型的区别", viewController: StaticDynamicTypeViewController.init()),
    IndexItemCellData(name: "hash方法的使用场景及重写意义", viewController: HashOCViewController.init()),
    IndexItemCellData(name: "使用并行队列和dispatch_barrier实现读写锁", viewController: ReadWriteLockViewController.init()),
    IndexItemCellData(name: "多线程示例及笔记", viewController: MultiThreadViewController.init()),
    IndexItemCellData(name: "atomic非线程安全论证", viewController: AtomicThreadNotSafeViewController.init()),
]

class IndexViewController: UIViewController {
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
        tableView.register(IndexCell.fromNib(), forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }
}

extension IndexViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = dataArray[indexPath.row]
        let cell:IndexCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! IndexCell
        cell.configure(cellData: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(dataArray[indexPath.row].viewController, animated: true);
    }
}
