//
//  IndexCell.swift
//  iOS Demo
//
//  Created by iMac on 2021/9/3.
//

import Foundation
import UIKit

class IndexItemCellData {
    var name : String = ""
//    var viewController : UIViewController
    var viewControllerClass : AnyClass = UIViewController.classForCoder()
    init(name:String, viewControllerClass:AnyClass) {
        self.name = name
        self.viewControllerClass = viewControllerClass
    }
}

class IndexCell : UITableViewCell {
    private var cellData : IndexItemCellData?
    @IBOutlet weak var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(cellData:IndexItemCellData) {
        self.cellData = cellData
        titleLabel.text = cellData.name
    }
    
    static func customClassName() -> String {
        return String(describing: self)
    }
    static func fromNib() -> UINib {
        return UINib.init(nibName: self.customClassName(), bundle: nil)
    }
}
