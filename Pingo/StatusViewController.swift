//
//  StatusViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 24/07/21.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var statusArray = ["I am who I am. Your approval is not needed.", "Work for a cause not applause. Live life to express not to impress", "Be brave. Take risks, nothing can substitute experience", "You haven't lost your smile! It's right there, under your nose. You must have forgotten where it was.", "Love is a lot like wildflowers. They tend to bloom in the most unlikely of places.", "If I could pick a rose each time I thought of you, I'd pick roses for the rest of my life.", "When you really love someone, their happiness matters so much more than your own.No matter how bad the sit", "I love the stars so fondly, I could never be fearful of the night.", "The earth creates beautiful music for those who listen. If an opportunity doesn't come knocking, build a door.", "Life is always better when you're laughing. So fine reason to smile and giggle each day.", "What is love? In math, it's an equation. In chemistry, it's a reaction. In history, it's a war.", "In art, it' I fell in love the moment I saw you, and you smiled at me because you knew.","The one emotion that can break your heart into a million pieces is the same emotion that glue the pieces", "Love is the only thing that can take you to heaven without you having to die first.", "I'm not afraid of dying. Death doesn't scare me either. It's losing I can make one promise to you: I will always love you more than any other person who enters your life.", "Never make a permanent decision because of your temporary emotions. Love is adorable when it's new, but it's most beautiful when it lasts.", "Today, someone asked me how life was. I just smiled and told him: She's doing just fine.", "I will wait for you because honestly, I don't want anyone else.", "A promise means everything But once it is broken, sorry means nothing.", "NO love, no pain, no gain, stay Single be Happy.", "Being single is about celebrating and appreciating your own space that you're in.", "If you love her, don't ever make her cry.", "You left without a reason, so please don't come back with an excuse.", "Happiness is homemade."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        AppUtility.lockOrientation(.portrait)
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
