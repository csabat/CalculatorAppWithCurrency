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
    @IBOutlet weak var currencyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var addedCurrencyField: UITextField!
    @IBOutlet weak var calcCurrencyField: UITextField!
    @IBOutlet weak var resultTextLabel: UILabel!
    @IBOutlet weak var currencyTextLabel: UILabel!
    //vars
    var userIsTyping = false
    var constantConstraintValue : CGFloat!
    var selectedTextField: UITextField?
    var calculatorLogic = CalculatorLogic()
    var keysArray : [String]?
    var isCurrencyTapped = false
    var rate: Double?
    //binding data to the curremcy display
    
    
    // Binding data to the displays labels 
    var currentDisplayNumber : Double {
        get {
            if resultTextLabel.text == "nan" {
                return 0
            } else {
                if let resultlLabelValue = Double(resultTextLabel.text!) {
                    return resultlLabelValue
                } else {
                    return 0
                }
            }
        }
        set {
            resultTextLabel.text = String(newValue).doubleFormatter()
            if let rate = rate {
                currencyTextLabel.text = String(getCurrencyValue(currentValue: currentDisplayNumber, rate: rate)).doubleFormatter()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyViewHeight.constant = 0.0
        keysArray = DataService.instance.getKeysArray()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRateValue), name: RATE_READY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorMessage), name: ERROR_FETCHING_RATES, object: nil)
    }

    
    //Observers func
    @objc func updateRateValue() {
        rate = DataService.instance.actualRate
        updateLabel()
    }
    //Handling Errors in case there is no connection
    @objc func showErrorMessage() {
        
        
    }
    
    //Binding currency real time
    func updateLabel() {
        let newNumber = getCurrencyValue(currentValue: currentDisplayNumber, rate: rate!)
        DispatchQueue.main.async {
            self.currencyTextLabel.text = String(newNumber).doubleFormatter()
        }
    }

    func getCurrencyValue(currentValue: Double, rate: Double) -> Double {
        let value = currentValue * rate
        let roundedValue = Double(round(1000*value)/1000)
        return roundedValue
    }
    
    @IBAction func numberBtnPressed(_ sender: CalculatorButton) {
        sender.animatedTouch()
        let number = sender.currentTitle!
        if userIsTyping == true {
            if resultTextLabel.text!.count > 9 {
            } else {
                resultTextLabel.text = resultTextLabel.text! + number
            }
            if let rate = rate {
                currencyTextLabel.text = String(getCurrencyValue(currentValue: currentDisplayNumber, rate: rate))
            }
        } else {
            
            resultTextLabel.text = number
            if let rate = rate {
                currencyTextLabel.text = String(getCurrencyValue(currentValue: currentDisplayNumber, rate: rate))
            }
            userIsTyping = true
        }
    }

    @IBAction func operationBtnPressed(_ sender: CalculatorButton) {
        sender.animatedTouch()
        userIsTyping = false
        calculatorLogic.setValue(newValue: currentDisplayNumber)
        guard let symbol = sender.currentTitle else {return}
        calculatorLogic.performResult(symbol)
        currentDisplayNumber = calculatorLogic.getValue()
        
    }
  
    @IBAction func currencyBtnPressed(_ sender: Any) {
        currencyViewAimating()
        setupCurrencyFields()
        createCurrencyPicker(to: calcCurrencyField)
        createCurrencyPicker(to: addedCurrencyField)
    }
    
    func currencyViewAimating() {
        UIView.animate(withDuration: 0.3, animations: {
            self.currencyViewHeight.constant = self.isCurrencyTapped ? 0.0 : 100.0
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 0.3, animations: {
                self.currencyLabelVisible(self.isCurrencyTapped)
                self.isCurrencyTapped = self.isCurrencyTapped ? false : true
                DataService.instance.fetchDataFromServer(calcKey: self.calcCurrencyField.text!, addedKey: self.addedCurrencyField.text!)
            })
        }
    }
    
    func setupCurrencyFields() {
        calcCurrencyField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        calcCurrencyField.textAlignment = NSTextAlignment.center
        addedCurrencyField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        addedCurrencyField.textAlignment = NSTextAlignment.center
    }
    
    func currencyLabelVisible(_ visible: Bool) {
        if visible {
            addedCurrencyField.isHidden = true
            calcCurrencyField.isHidden = true
            addedCurrencyField.alpha = 0
            calcCurrencyField.alpha = 0
        } else {
            addedCurrencyField.isHidden = false
            calcCurrencyField.isHidden = false
            addedCurrencyField.alpha = 1
            calcCurrencyField.alpha = 1
            currencyTextLabel.isHidden = false
            currencyTextLabel.alpha = 1
        }
    }

    func createCurrencyPicker(to textfield: UITextField) {
        let currencyPicker = UIPickerView()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        textfield.inputView = currencyPicker
        currencyPicker.backgroundColor = #colorLiteral(red: 0.2006070614, green: 0.2007901967, blue: 0.2006354332, alpha: 1)
        createToolBar(to: textfield)
    }
    
    func createToolBar(to textfield: UITextField) {
        print("creating toolbar")
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = .black
        toolbar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.dismissToolbar))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textfield.inputAccessoryView = toolbar
    }
    
    @objc func dismissToolbar() {
        DataService.instance.fetchDataFromServer(calcKey: calcCurrencyField.text!, addedKey: addedCurrencyField.text!)
        view.endEditing(true)
    }
    
}

// UIPickerView
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return keysArray?.count ?? 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return keysArray?[row] ?? ""
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedTextfield = selectedTextField {
            selectedTextfield.text = keysArray?[row]
            
            
        }
    }
    
    //Custom rows
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Medium", size: 30.0)
        label.text = keysArray?[row]
        return label
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    
}




