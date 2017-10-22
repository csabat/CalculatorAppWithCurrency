//
//  ViewController.swift
//  Calculator
//
//  Created by admin on 20/10/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Outlets
    @IBOutlet weak var addedCurrencyField: UITextField!
    @IBOutlet weak var calcCurrencyField: UITextField!
    @IBOutlet weak var resultTextLabel: UILabel!
    @IBOutlet weak var currencyTextLabel: UILabel!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    var calculatorLogic = CalculatorLogic()
    var keysArray : [Any]?
    var currentDisplayNumber : Double {
        get {
            return Double(resultTextLabel.text!)!
        }
        
        set {
            resultTextLabel.text = String(newValue).doubleFormatter()
        }
    }
    
    var userIsTyping = false
    var constantConstraintValue : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //constantConstraintValue = stackViewTopConstraint.constant
        var _ = DataService.instance.fetchDataFromServer(key: "AUD")
        //put THem in currencyBUtton pressed
        setupCurrencyFields()
        //createToolBar(to: calcCurrencyField)
        
        
    }
    func setupCurrencyFields() {
        calcCurrencyField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        calcCurrencyField.textAlignment = NSTextAlignment.center
        addedCurrencyField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        addedCurrencyField.textAlignment = NSTextAlignment.center
    }

    @IBAction func numberBtnPressed(_ sender: CalculatorButton) {
        sender.animatedTouch()
        let number = sender.currentTitle!
        if userIsTyping == true {
            resultTextLabel.text = resultTextLabel.text! + number
        } else {
            resultTextLabel.text = number
            userIsTyping = true
        }
        
    }
    
    
    @IBAction func operationBtnPressed(_ sender: CalculatorButton) {
        userIsTyping = false
        calculatorLogic.setValue(newValue: currentDisplayNumber)
        guard let symbol = sender.currentTitle else {return}
        calculatorLogic.performResult(symbol)
        currentDisplayNumber = calculatorLogic.getValue()
        
        
        
    }
    
    @IBAction func equalBtnPressed(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func acBtnPressed(_ sender: Any) {
        
    }
    
    var isCurrencyTapped = false
    
    @IBAction func currencyBtnPressed(_ sender: Any) {
        triggerConstrint()
    }
    
    
//    var selectedTextField: UITextField = UITextField()
//    //to textfield: UITextField
//    func createCurrencyPicker() {
//        //selectedTextField = textfield
//
//        let currencyPicker = UIPickerView()
//        currencyPicker.delegate = self
//
//
//        calcCurrencyField.inputView = currencyPicker
//    }
//    //to textfield: UITextField
//    func createToolBar() {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.dismissToolbar))
//
//        toolbar.setItems([doneButton], animated: false)
//        toolbar.isUserInteractionEnabled = true
//
//        calcCurrencyField.inputAccessoryView = toolbar
//
//    }
//
//    @objc func dismissToolbar() {
//        view.endEditing(true)
//    }
    
    
    
    func triggerConstrint() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.stackViewTopConstraint.constant = self.isCurrencyTapped ? self.constantConstraintValue : self.currencyTextLabel.frame.size.height
            
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.currencyTextLabel.alpha = self.isCurrencyTapped ?  0 : 1
            })
            
            self.isCurrencyTapped = self.isCurrencyTapped ? false : true
        }
        
//        UIView.animate(withDuration: 0.3, animations: {

//            self.view.layoutIfNeeded()
//        }) { (success) in
//            UIView.animate(withDuration: 0.3, animations: {
//                self.currencyTextLabel.alpha = 1
//            })
//            self.isCurrencyTapped = self.isCurrencyTapped ? false : true
//        }
    }
    

}

//extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        guard let array = keysArray else {return 1}
//        return array.count
//    }
//
//    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        guard let array = keysArray else {return ""}
//        return array[row] as? String
//    }
//
//    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        guard let array = keysArray else {return}
//        selectedTextField.text = array[row] as? String
//    }
//
//}
//

