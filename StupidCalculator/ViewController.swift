//
//  ViewController.swift
//  StupidCalculator
//
//  Created by Claudio Portuesi on 13/11/2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberField.adjustsFontSizeToFitWidth = true
        numberField.minimumScaleFactor = 0.5;
        numberField.text = ""
        initializeButtons()
    }
    
    
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var equalsButton: UIButton!
    @IBOutlet weak var acButton: UIButton!
    @IBOutlet weak var minusPlusButton: UIButton!
    @IBOutlet weak var percentButton: UIButton!
    @IBOutlet weak var comaButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    
    @IBOutlet weak var numberField: UILabel!
    var secondNumber: String? = nil
    var operationTag: Buttons? = nil
    
    func initializeButtons() {
        //green buttons
        initializeButton(button: divideButton, title: nil, action: nil, rounded: false)
        initializeButton(button: multiplyButton, title: nil, action: nil, rounded: false)
        initializeButton(button: minusButton, title: nil, action: nil, rounded: false)
        initializeButton(button: plusButton, title: nil, action: nil, rounded: false)
        initializeButton(button: equalsButton, title: nil, action: nil, rounded: false)
        
        //blue buttons
        initializeButton(button: acButton, title: nil, action: nil, rounded: true)
        initializeButton(button: minusPlusButton, title: nil, action: nil, rounded: true)
        initializeButton(button: percentButton, title: nil, action: nil, rounded: true)
        
        //gray buttons
        initializeButton(button: comaButton, title: nil, action: nil, rounded: true);
        initializeButton(button: zeroButton, title: nil, action: nil, rounded: true);
        initializeButton(button: oneButton, title: nil, action: nil, rounded: true);
        initializeButton(button: twoButton, title: nil, action: nil, rounded: true);
        initializeButton(button: threeButton, title: nil, action: nil, rounded: true);
        initializeButton(button: fourButton, title: nil, action: nil, rounded: true);
        initializeButton(button: fiveButton, title: nil, action: nil, rounded: true);
        initializeButton(button: sixButton, title: nil, action: nil, rounded: true);
        initializeButton(button: sevenButton, title: nil, action: nil, rounded: true);
        initializeButton(button: eightButton, title: nil, action: nil, rounded: true);
        initializeButton(button: nineButton, title: nil, action: nil, rounded: true);
    }
    
    func initializeButton(button: UIButton, title: String?, action: Selector?, rounded: Bool) {
        //divide_button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        
        if(rounded) {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        } else {
            button.layer.cornerRadius = CGFloat(M_1_PI - 0.05) * button.bounds.size.width
        }

        button.clipsToBounds = true
        
        if(title != nil) {
            button.setTitle(title, for: .normal)
        }
        
        //button.addTarget(self, action: action, for: .touchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func onTapNumbers(_ sender: UIButton) {
        //numberField.text = sender.title(for: .normal)
        append(string: sender.title(for: .normal)!)
        acButton.setTitle("C", for: .normal)
    }
    
    @IBAction func onTapComa(_ sender: UIButton) {
        let title = sender.title(for: .normal) //,
        
        if(!isNumberFieldClear() && !(numberField.text?.contains(title!))!) {
            append(string: title!)
        }
    }
    
    @IBAction func onTapSignsOrPercentage(_ sender: UIButton) {
        if(isNumberFieldClear()) {
            return
        }
        
        if(sender.tag == Buttons.MINUS_PLUS_BUTTON.rawValue) {
            if(numberField.text!.starts(with: "-")) {
                updateNumber(string: numberField.text!.substring(from: String.Index(encodedOffset: 1)))
            } else {
                appendFromBeginning(string: "-")
            }
        } else {
            let number : Double = convertToDouble(string: numberField.text!)
            updateNumber(string: String(number / 100))
        }
    }
    
    
    @IBAction func onTapOperations(_ sender: UIButton) {
        if(!isNumberFieldClear()) {
            if(!isNumberFieldClear()) {
                secondNumber = numberField.text
            }
            
            clearNumber()
            resetOperationButtons()
            sender.backgroundColor = UIColor(named: "Tasto Selezionato")
            setOperationTag(tag: Buttons(rawValue: sender.tag)!)
        }
    }
    
    @IBAction func onTapEquals(_ sender: UIButton) {
        if(!isNumberFieldClear()) {
            resetOperationButtons()
            var toReturn: String = numberField.text!
            
            if(isWatingForOperation()) {
                if(operationTag == Buttons.DIVIDE_BUTTON) {
                    toReturn = convertToString(double: convertToDouble(string: secondNumber!) / convertToDouble(string: numberField.text!))
                } else if(operationTag == Buttons.MULTIPLY_BUTTON) {
                    toReturn = convertToString(double: convertToDouble(string: secondNumber!) * convertToDouble(string: numberField.text!))
                } else if(operationTag == Buttons.MINUS_BUTTON) {
                    toReturn = convertToString(double: convertToDouble(string: secondNumber!) - convertToDouble(string: numberField.text!))
                } else if(operationTag == Buttons.PLUS_BUTTON) {
                    toReturn = convertToString(double: convertToDouble(string: secondNumber!) + convertToDouble(string: numberField.text!))
                } //mettere il periodico e mettere che quando scrivi troppo si resiza e mettere che si può spammare uguale
            }
            
            updateNumber(string: toReturn)
        }
    }
    
    func isNumberFieldClear() -> Bool {
        return numberField.text == ""
    }
    
    func isWatingForOperation() -> Bool {
        return operationTag != nil
    }
    
    func setOperationTag(tag: Buttons) {
        operationTag = tag
    }
    
    func resetOperations() {
        operationTag = nil
    }
    
    func AC() {
        resetOperations()
        clearNumber()
        acButton.setTitle("AC", for: .normal)
        
        resetOperationButtons()
    }
    
    func resetOperationButtons() {
        resetOperationColor(button: divideButton)
        resetOperationColor(button: multiplyButton)
        resetOperationColor(button: minusButton)
        resetOperationColor(button: plusButton)
    }
    
    func resetOperationColor(button: UIButton) {
        button.backgroundColor = UIColor(named: "Verdino")
    }
    
    func convertToString(double: Double) -> String {
        var string = String(double)
        let index = String.Index(encodedOffset: string.count - 2)
        
        if(string.substring(from: index) == ".0") {
            string = String(string.dropLast().dropLast())
        } else {
            string = string.replaceLast(of: ".", with: ",")
        }
        
        return string
    }
    
    func convertToDouble(string: String) -> Double {
        return Double(replaceComaToDot(string: string))!
    }
    
    func replaceComaToDot(string: String) -> String {
        return string.replacingOccurrences(of: ",", with: ".")
    }
    
    func replaceDotToComa(string: String) -> String {
        return string.replacingOccurrences(of: ".", with: ",")
    }
    
    @IBAction func onTapAC(_ sender: UIButton) {
        AC()
    }
    
    func clearNumber() {
        updateNumber(string: "")
    }
    
    func updateNumber(string: String) {
        if(string.count >= 9) {
            return
        }
        
        numberField.text = string
    }
    
    func append(string: String) {
        updateNumber(string: numberField.text! + string)
    }
    
    func appendFromBeginning(string: String) {
        updateNumber(string: string + numberField.text!)
    }
    
    enum Buttons: Int {
        case DIVIDE_BUTTON //0
        case MULTIPLY_BUTTON //1
        case MINUS_BUTTON //2
        case PLUS_BUTTON //3
        case EQUALS_BUTTON //4
        
        case AC_BUTTON //5
        case MINUS_PLUS_BUTTON //6
        case PERCENT_BUTTON //7
        
        case COMA_BUTTON //8
        
        case USELESS_BUTTON //9
        
        case ZERO_BUTTON //10
        case ONE_BUTTON //11
        case TWO_BUTTON //12
        case THREE_BUTTON //13
        case FOUR_BUTTON //14
        case FIVE_BUTTON //15
        case SIX_BUTTON //16
        case SEVEN_BUTTON //17
        case EIGHT_BUTTON //18
        case NINE_BUTTON //19
    }
}
