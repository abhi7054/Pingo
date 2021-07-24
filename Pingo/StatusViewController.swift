//
//  StatusViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 24/07/21.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var statusArray = ["I am who I am. Your approval is not needed.", "Work for a cause not applause. Live life to express not to impress", "Be brave. Take risks, nothing can substitute experience", "Status description", "Status description", "Status description", "Status description", "Status description", "Status description"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

}
extension StatusViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fontTableViewCell") as! FontTableViewCell
        
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = true
        
        cell.enterText.text = statusArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIPasteboard.general.string = statusArray[indexPath.row]
    }
}
