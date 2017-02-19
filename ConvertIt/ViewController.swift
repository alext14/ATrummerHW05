//
//  ViewController.swift
//  ConvertIt
//
//  Created by CSOM on 2/18/17.
//  Copyright © 2017 CSOM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    struct Formula {
    var conversionString: String
    var formula: (Double) -> Double
    }
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var posNeg: UISegmentedControl!
    
    let formulasArray = [Formula(conversionString: "miles to kilometers", formula: {$0 / 0.62137}),
                         Formula(conversionString: "kilometers to miles", formula: {$0 * 0.62137}),
                         Formula(conversionString: "feet to meters", formula: {$0 / 3.2808}),
                         Formula(conversionString: "yards to meters", formula: {$0 / 1.0936}),
                         Formula(conversionString: "meters to feet", formula: {$0  * 3.2808}),
                         Formula(conversionString: "meters to yards", formula: {$0 * 1.0936}),
                         Formula(conversionString: "inches to centimeters", formula: {$0 / 0.3970}),
                         Formula(conversionString: "centimeters to inches", formula: {$0 * 0.3970}),
                         Formula(conversionString: "fahrenheit to celsius", formula: {($0 - 32) * (5/9)}),
                         Formula(conversionString: "celsius to fahrenheit", formula: {($0 * (9/5)) + 32}),
                         Formula(conversionString: "quarts to liters", formula: {$0 / 1.05669}),
                         Formula(conversionString: "liters to quarts", formula: {$0 * 1.05669})]
    
    var toUnits = ""
    var fromUnits = ""
    var conversionString = ""
    var rowSelected = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formulaPicker.dataSource = self
        formulaPicker.delegate = self
        
        userInput.delegate = self
        
        conversionString = formulasArray[0].conversionString
        
        assignUnits()
        
        userInput.becomeFirstResponder()
    }
    //not used...deletable
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignUnits() {
        let unitsArray = conversionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        resultsLabel.text = ""
        
        posNeg.selectedSegmentIndex = 0
        return true
    }
    
    func calculateConversion() {
        // Local variables declared and initalized.
        var inputValue = 0.0
        var outputValue = 0.0
        var outputString = ""
        
    
        if let inputValue = Double(userInput.text!) {
            
            outputValue = formulasArray[rowSelected].formula(inputValue)
        } else {
            
            showAlert(title: "Error:", message: "Please enter a valid number. Not an empty string, no commas, symbols, or non-numeric characters.")
        }
        
        if decimalSegment.selectedSegmentIndex < 3 {
            outputString = String(format: "%."+String(decimalSegment.selectedSegmentIndex+1)+"f", outputValue)
        } else {
            outputString = String(outputValue)
        }
        
        
        resultsLabel.text = "\(userInput.text!) \(fromUnits) = \(outputString) \(toUnits)"
    }
    
    // MARK:- Delegates & DataSources, Required Methods for UIPickerView
    
    // A required UIPickerView function. Sets our picker so that it has only one column (component).
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Required UIPickerView function, sets up the pickerView so that it has as many rows as we have
    // elements in our formulasArray (which is our datasource for the pickerView).
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulasArray.count
    }
    
    // Required UIPickerView function that uses formulasArray as a datasource to populate the rows
    // of the pickerView.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulasArray[row].conversionString
    }
    
    // This function is called whenever the user selects a row in the UIPickerView.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rowSelected = row
        
        conversionString = formulasArray[row].conversionString
        
        assignUnits()
        
        if conversionString == "celsius to fahrenheit" || conversionString == "fahrenheit to celsius" {
            posNeg.isHidden = false
        } else {
            posNeg.isHidden = true
            userInput.text = userInput.text!.replacingOccurrences(of: "-", with: "")
            // And also set the segmented index for "+/-" to zero, which is "+". This way we won't
            // have "-" selected incorrectly if we return to a temperature row.
            posNeg.selectedSegmentIndex = 0
        }
                if userInput.text?.characters.count != 0 {
            calculateConversion()
        }
    }
    
    // MARK:- @IBActions
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConversion()
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        calculateConversion()
    }
    
    @IBAction func posNegPressed(_ sender: UISegmentedControl) {
        
        if posNeg.selectedSegmentIndex == 1 {
            userInput.text = "-" + userInput.text!
        } else {
            userInput.text = userInput.text!.replacingOccurrences(of: "-", with: "")
        }
                if userInput.text != "-" {             calculateConversion()
        }
    }
}
