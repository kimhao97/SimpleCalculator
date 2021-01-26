import UIKit

enum Operator {
    case add, sub, mul, div, percent, nav
}

class ViewController: UIViewController {
    @IBOutlet weak private var doingLabel: UILabel!
    @IBOutlet weak private var resultLabel: UILabel!
    
    private var numbers: [Float] = []
    private var operators: [Operator] = []
    private var isDecimalPoint = false
    private var isClear = false
    private var index: Int = 0 {
        didSet {
            isDecimalPoint = false
        }
    }
    
    private var numberString: String = "" {
        didSet {
            if (isClear) {
                numbers.removeAll()
                doingString.removeAll()
                resultString.removeAll()
                isClear = false
            }
            
            if doingString.first == "0" {
                doingString.removeAll()
            }
            
            doingString.append(numberString)
            
            if numbers.isEmpty {
                numbers.append(Float(numberString) ?? 0)
            } else {
                if(numbers.count == index) {
                    numbers.append(0)
                }
                
                if isDecimalPoint {
                    numbers[index] = numbers[index] + (Float(numberString) ?? 0) / 10
                }else {
                    numbers[index] = numbers[index] * 10 + (Float(numberString) ?? 0 )
                }
            }
            numberString.removeAll()
        }
    }
    
    private var operatorString: String = "" {
        didSet {
            if (isClear) {
                numbers.removeAll()
                doingString.removeAll()
                resultString.removeAll()
                isClear = false
            }
            
            switch operatorString {
            case "+":
                operators.insert(.add, at: index)
            case "-":
                operators.insert(.sub, at: index)
            case "x":
                operators.insert(.mul, at: index)
            case "/":
                operators.insert(.div, at: index)
            case "%":
                operators.insert(.percent, at: index)
            case "+/-":
                operators.insert(.nav, at: index)
            case ".":
                isDecimalPoint = true
            default:
                break
            }
            
            if operatorString != "." {
                index += 1
            }
            
            doingString.append(contentsOf: " " + operatorString + " ")
            operatorString.removeAll()
        }
    }
    
    private var doingString: String = "" {
        didSet {
            doingLabel.text = doingString
        }
    }
    
    private var resultString: String = "" {
        didSet {
            let result: Double = Double(resultString) ?? 0
            if result.truncatingRemainder(dividingBy: 1) == 0 {
                resultLabel.text = String(format: "%.0f", result)
            } else {
                resultLabel.text = String(format: "%.2f", result)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Clear action
    @IBAction private func clearTouchUpInside(_ sender: Any) {
        guard doingString.isEmpty  else {
            numbers.removeAll()
            doingString.removeAll()
            resultString.removeAll()
            return
        }
    }
    
    //MARK: - Equal Action
    @IBAction private func equalTouchUpInside(_ sender: Any) {
        isClear = true
        if index == 0 {
            resultString = "\(numbers.first ?? 0)"
        } else {
            // percent
            var i: Int = 0
            repeat {
                if operators[i] == .percent {
                    numbers[i] = numbers[i] / 100
                    operators.remove(at: i)
                    index -= 1
                } else {
                    i += 1
                }
            } while i < index
            
            // mul, div
            i = 0
            if index != 0 {
                repeat {
                    if operators[i] == .mul || operators[i] == .div {
                        switch operators[i] {
                        case .mul:
                            numbers[i] = numbers[i] * numbers[i+1]
                        case .div:
                            numbers[i] = numbers[i] / numbers[i+1]
                        case .percent:
                            numbers[i] = numbers[i] / 100
                        default:
                            break
                        }
                        numbers.remove(at: i+1)
                        operators.remove(at: i)
                        index -= 1
                    } else {
                        i += 1
                    }
                } while i < index
            }
            
            
            // add, sub
            if index != 0 {
                i = 0
                repeat {
                    if operators[i] == .add || operators[i] == .sub {
                        switch operators[i] {
                        case .add:
                            numbers[i] = numbers[i] + numbers[i+1]
                        case .sub:
                            numbers[i] = numbers[i] - numbers[i+1]
                        default:
                            break
                        }
                        numbers.remove(at: i+1)
                        operators.remove(at: i)
                        index -= 1
                    } else {
                        i += 1
                    }
                } while i < index
            }
            resultString = "\(numbers.first ?? 0)"
        }
    }
    
    //MARK: - Number and Arthemetic operators action
    @IBAction private func touchUpInside(_ sender: UIButton) {
        let dataString: String = sender.title(for: .normal)!
        let number: Int? = Int(dataString)
        if number != nil {
            numberString.append(dataString)
        } else {
            operatorString.append(dataString)
        }
    }
}
