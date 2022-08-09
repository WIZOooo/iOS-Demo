//
//  IndexCell.swift
//  iOS Demo
//
//  Created by iMac on 2021/9/3.
//

import Foundation
import UIKit

struct IndexItemCellData {
    var name : String
    var viewController : UIViewController
}

class IndexCell : UITableViewCell {
    private var cellData : IndexItemCellData?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(cellData:IndexItemCellData) {
        self.cellData = cellData;
        let label = UILabel.init()
        label.text = cellData.name
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.frame = CGRect.init(x: 20, y: 20, width: 100, height: 30)
        self.contentView.addSubview(label)
    }
    
    func targetVC() -> UIViewController {
        self.cellData?.viewController ?? UIViewController.init()
    }
}
