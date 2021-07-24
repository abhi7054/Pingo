//
//  FancyLettersViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 23/07/21.
//

import UIKit

class FancyLettersViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var enterTextField: UITextField!
    
    var text = "Enter your text here"
    
    var fontArray = ["80db", "Baisley", "BitterPastryDemoRegular", "colour", "COMICATE", "enervate", "Hallies", "horrendo", "JackRollDemoRegular", "Kelly Stones", "LeadCoat", "orangejuice", "perfect", "RemachineScriptPersonalUse", "SewerSys", "WaltographUI-Bold", "Xposed", "Zapfino"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableVIew.dataSource = self
        tableVIew.delegate = self
        
        enterTextField.delegate = self
        
        for family in UIFont.familyNames {
            print("\(family)")

            for name in UIFont.fontNames(forFamilyName: family) {
                print("\(name)")
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        AppUtility.lockOrientation(.portrait)
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        enterTextField.resignFirstResponder()
    }
    
    

}

extension FancyLettersViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fontArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fontTableViewCell") as! FontTableViewCell
        
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = true
        
        cell.enterText.text = text
        
        cell.enterText.font = UIFont(name: fontArray[indexPath.row], size: 16.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIPasteboard.general.string = text
    }
}

extension FancyLettersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // to be always updated, you cannot use textField.text directly, because after this method gets called, the textField.text will be changed
        let newStringInTextField = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
                
        text = newStringInTextField!
        
        tableVIew.reloadData()
        return true
    }
}
