//
//  ClassStructViewController.swift
//  iOS Demo
//
//  Created by iMac on 2022/8/12.
//

import UIKit

protocol AnimalCommonProtocol {
    var name: String? { get set }
    var weight: Double { get set }
    func run()
}

struct Cat : AnimalCommonProtocol {
    func run() {
        print("cat run")
    }
    var name: String?
    var weight: Double
    var gender: String?
}

struct Dog : AnimalCommonProtocol {
    func run() {
        print("dog run")
    }
    
    var name: String?
    var weight: Double
    var type: String?
}

class Animal {
    var name: String?
    var weight = 0.0
}


class ClassStructViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let cat = Animal()
        cat.name = "cat"
        cat.weight = 10

        print("cat's name: \(cat.name!), cat's weight: \(cat.weight)") //cat's name: cat, cat's weight: 10.0

        // 传递的是引用
        let blackCat = cat
        blackCat.name = "blackCat"

        print("cat's name: \(cat.name!)") // cat's name: blackCat
        
        /// ===：代表两个变量或者常量引用的同一个instance
        /// ==：代表两个变量或者常量的值是否相同，默认无法比较类的实例，需要重写==操作符才行
        if blackCat === cat {
            print("Identical") //Identical
        } else {
            print("Not identical")
        }
    }
}
