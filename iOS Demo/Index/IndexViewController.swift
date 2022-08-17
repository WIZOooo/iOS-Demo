//
//  ViewController.swift
//  iOS Demo
//
//  Created by iMac on 2021/9/3.
//

import UIKit

fileprivate let dataArray : [IndexItemCellData] = [
    IndexItemCellData.init(name: "UIView CALayer", viewControllerClass: CALayerUIViewViewController.classForCoder()),
    IndexItemCellData.init(name: "Block Swift", viewControllerClass: BlockSwiftViewController.classForCoder()),
    IndexItemCellData.init(name: "Block OC", viewControllerClass: BlockOCViewController.classForCoder()),
    IndexItemCellData.init(name: "PlaygroundOC", viewControllerClass: PlaygroundOCViewController.classForCoder()),
    IndexItemCellData.init(name: "PlaygroundSwift", viewControllerClass: PlaygroundSwiftViewController.classForCoder()),
    IndexItemCellData.init(name: "self和super", viewControllerClass: SelfSuperViewController.classForCoder()),
    IndexItemCellData.init(name: "静态类型与动态类型的区别", viewControllerClass: StaticDynamicTypeViewController.classForCoder()),
    IndexItemCellData.init(name: "hash方法的使用场景及重写意义", viewControllerClass: HashOCViewController.classForCoder()),
    IndexItemCellData.init(name: "使用并行队列和dispatch_barrier实现读写锁", viewControllerClass: ReadWriteLockViewController.classForCoder()),
    IndexItemCellData.init(name: "多线程示例及笔记", viewControllerClass: MultiThreadViewController.classForCoder()),
    IndexItemCellData.init(name: "atomic非线程安全论证", viewControllerClass: AtomicThreadNotSafeViewController.classForCoder()),
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
        let cls: UIViewController.Type = dataArray[indexPath.row].viewControllerClass as! UIViewController.Type
        let vc : UIViewController = cls.init()
        self.navigationController?.pushViewController(vc, animated: true);
    }
}
