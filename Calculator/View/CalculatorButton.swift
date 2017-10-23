//
//  CalculatorButton.swift
//  Calculator
//
//  Created by admin on 20/10/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

@IBDesignable
class CalculatorButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = 15.0
        
    }
    
}


extension CalculatorButton {
    func animatedTouch() {
        let originalBackgroundColor = self.backgroundColor
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = originalBackgroundColor
            })
        })
    }
}



    
    
    

