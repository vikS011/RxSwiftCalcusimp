

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

enum Operations {
    case add, subtract, multiply, divide
}

class CalculatorView : UIView {
    internal let regularCalculatorViewModel = RegularCalculatorViewModel()
    func resetRegularButtonBorder() {
        regularCalculatorViewModel.resetButtonBorder();
    }
    
    
}

class RegularCalculatorViewModel : UIView {
    
    internal var output = BehaviorRelay<String>(value: "0")
    internal var disposeBag = DisposeBag()
     var buttons = [UIButton]()
    
     var isConstraints : Bool = false
    
     var prevIndex : Int = 0
     let CAPACITY : Int = 19
    
     let operations : [String] = [".", "=", "+", "-", "x", "/", "AC", "+/-", "%"]
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !isConstraints {
            setupButtons()
            setupConstraints()
        }
    }
    
     func setupButtons() {
        for i in 0..<CAPACITY {
            let button = UIButton()
            button.layer.borderWidth = 1
            button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 24)
            button.translatesAutoresizingMaskIntoConstraints = false
            switch(i / 10) {
            case 1:
                button.setTitle(operations[i % 10], for: .normal)
                button.setTitleColor(.black, for: .normal)
                switch(i % 10) {
                case 0:
                    button.backgroundColor = UIColor.orange
                    button.setTitleColor(.black, for: .normal)
                case 1...5:
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = UIColor.orange
                case 7...8:
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = UIColor.orange
                case 6:
                    button.setTitleColor(.red, for: .normal)
                    button.backgroundColor = UIColor.orange
                    
                case 7...8:
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = UIColor.orange
                    
                default:
                    button.setTitleColor(.white, for: .normal)
                    button.backgroundColor = UIColor.orange
                }
                buttons.append(button)
            default:
                
                
                button.setTitle(String(i), for: .normal)

                
                button.setTitleColor(.blue, for: .normal)
                button.backgroundColor = UIColor.lightGray
                buttons.append(button)
            }
        }
        isConstraints = true
    }
     
     func setupConstraints() {
        for i in 0..<buttons.count {
            addSubview(buttons[i])
            
            switch(i / 11) {
                
            case 1:
                buttons[i].heightToSuperview(multiplier: 0.2)
                buttons[i].widthToSuperview(multiplier: 0.25)
                
                switch (i) {
                case 11:
                    buttons[i].bottomToSuperview()
                    buttons[i].leftToRight(of: buttons[i - 1])
                case 12, 13, 14, 15:
                    buttons[i].bottomToTop(of: buttons[i - 1])
                    buttons[i].leftToRight(of: buttons[10])
                case 16:
                    buttons[i].bottomToTop(of: buttons[7])
                    buttons[i].leftToSuperview()
                default:
                    buttons[i].bottomToTop(of: buttons[i - 9])
                    buttons[i].leftToRight(of: buttons[i - 1])
                }
                buttons[i].rx.tap.subscribe(onNext: { [weak self]_ in
                    self?.output.accept(self?.buttons[i].titleLabel?.text ?? "")
                    self?.changeButtonBorder(index: i)
                }).disposed(by: disposeBag)
                
            default:
                if i != 0 {
                    buttons[i].heightToSuperview(multiplier: 0.2)
                    buttons[i].widthToSuperview(multiplier: 0.25)
                }
    
                
                switch(i) {
                case 0:
                    buttons[i].heightToSuperview(multiplier: 0.2)
                    buttons[i].widthToSuperview(multiplier: 0.5)
                    
                    buttons[i].bottomToSuperview()
                    buttons[i].leftToSuperview()
                case 1:
                    buttons[i].bottomToTop(of: buttons[i - 1])
                    buttons[i].leftToSuperview()
                case 2, 3:
                    buttons[i].bottomToTop(of: buttons[0])
                    buttons[i].leftToRight(of: buttons[i - 1])
                case 4,7:
                    buttons[i].bottomToTop(of: buttons[i - 3])
                    buttons[i].leftToSuperview()
                case 10:
                    buttons[i].bottomToSuperview()
                    buttons[i].leftToRight(of: buttons[i - 10])
                default:
                    buttons[i].bottomToTop(of: buttons[i - 3])
                    buttons[i].leftToRight(of: buttons[i - 1])
                }
                buttons[i].rx.tap.subscribe(onNext: { [weak self] _ in
                    self?.output.accept(self?.buttons[i].titleLabel?.text ?? "")
                    self?.highlightButtonBorder(index: i)
                }).disposed(by: disposeBag)
            }
        }
    }
    
     func highlightButtonBorder (index : Int) {
        buttons[index].layer.borderWidth = 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.buttons[index].layer.borderWidth = 1
        })
    }
    
     func resetButtonBorder() {
        if prevIndex != 0 {
            buttons[prevIndex].layer.borderWidth = 1
        }
    }
    
     func changeButtonBorder (index : Int) {
        switch(index) {
        case 11, 16:
            resetButtonBorder()
            prevIndex = 0
        case 17, 18:
            resetButtonBorder()
            prevIndex = 0
            highlightButtonBorder(index: index)
        default:
            resetButtonBorder()
            buttons[index].layer.borderWidth = 3
            prevIndex = index
        }
    }
}



