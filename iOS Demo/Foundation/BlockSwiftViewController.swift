//
//  BlockSwiftViewController.swift
//  iOS Demo
//
//  Created by iMac on 2022/8/15.
//

import UIKit


class Pokemon: CustomDebugStringConvertible {
    var name: String
    init(name: String) {
        self.name = name
    }
    var debugDescription: String { return "<Pokemon \(name)>" }
    deinit { print("\(self) escaped!") }
}

func delay(seconds: Int, closure: @escaping ()->()) {
    let time = DispatchTime.now() + .seconds(seconds)
    DispatchQueue.main.asyncAfter(deadline: time, execute: DispatchWorkItem(block: {
        print("🕑")
        closure()
    }))
}

func demo7() {
    var pokemon = Pokemon(name: "Mew")
    print("➡️ Initial pokemon is \(pokemon)") // Mew
    
    delay(seconds: 1) {
        [capturedPokemon = pokemon] in
        print("closure 1 — pokemon captured at creation time: \(capturedPokemon)")// Mew
        print("closure 1 — variable evaluated at execution time: \(pokemon)") //Mewtwo
        pokemon = Pokemon(name: "Pikachu")
        print("closure 1 - pokemon has been now set to \(pokemon)")// Pikachu
    }
    
    pokemon = Pokemon(name: "Mewtwo")
    print("🔄 pokemon changed to \(pokemon)")// Mewtwo
    
    delay(seconds: 2) {
        [capturedPokemon = pokemon] in
        print("closure 2 — pokemon captured at creation time: \(capturedPokemon)") //Pikachu
        print("closure 2 — variable evaluated at execution time: \(pokemon)")//Pikachu
        pokemon = Pokemon(name: "Charizard")
        print("closure 2 - value has been now set to \(pokemon)")//Charizard
    }
}


class BlockSwiftViewController: UIViewController {
    var name :String?
    var referenceLoopBlock:((Int, Int)->(String))? //定义闭包属性，VC强引用闭包

    override func viewDidLoad() {
        super.viewDidLoad()
//        blockImplicitCapture()
        blockCaptureList()
//        demo7()
    }
    
    // Block隐式捕获变量
    func blockImplicitCapture() {
        /// 结果打印after，
        /// 因为闭包复制了一份指向pokeman指针的指针，
        /// 所以当pokeman指针发生变化时，闭包中指向pokeman指针的指针也发生了变化
        var pokeman = Pokemon(name: "before")
        let block1 = { // 最简单的闭包 内部引用了变量
            print("\(pokeman.name)")
        }
        pokeman = Pokemon(name: "after")
        block1()
    }
    
    // Block 捕获变量
    func blockCaptureList() {
        /// 结果打印after，
        /// 因为闭包通过捕获列表复制了一份pokeman指针，两个指针指向的内容相同
        /// 所以当pokeman指针发生变化时，闭包中指向原内容的指针未变化
        var pokeman = Pokemon(name: "before")
        let block2 = { [capturedPokeman = pokeman] in //声明捕获列表 捕获变量 而非引用
            //num += 1 // 此处会报错:Left side of mutating operator isn't mutable: 'num' is an immutable capture
            print("\(capturedPokeman.name)")
        }
        pokeman = Pokemon(name: "after")
        block2()
    }
    
    // 循环引用
    func testReferenceLoop() {
        /// 使用weak关键字避免循环引用
        /// 当被捕获变量的生命周期小于当前类时，可以使用weak，
        /// 当被捕获变量被释放时，捕获列表中的指针自动置为nil
        self.referenceLoopBlock = {
            [weak self]
            (a:Int, b:Int)-> String in
            guard let `self` = self else {return ""} // 持有变量防止变量被释放，使用部分关键来声明临时变量
            //闭包访问VC的其他成员，闭包捕获并强引用self对象
            self.name = "x"
            return self.name ?? ""
        }
        
        /// 使用unown关键字避免循环引用
        /// 当被捕获变量的生命周期大于当前类时，可以使用unown，
        /// 当被捕获变量被释放时，捕获列表中的指针不会自动置为nil，访问可能崩溃
        self.referenceLoopBlock = {
            [unowned self]
            (a:Int, b:Int)-> String in
            //闭包访问VC的其他成员，闭包捕获并强引用self对象
            self.name = "x"
            return self.name!
        }
        
    }

}
