//
//  WallpapersViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 23/07/21.
//

import UIKit
import JGProgressHUD
class WallpapersViewController: UIViewController{
    
    var imageURLs: [String]!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    
    var current = 0
    let hud=JGProgressHUD()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchURLs()
        AppUtility.lockOrientation(.portrait)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        
        
        writeToPhotoAlbum(image: image)
    }
    @IBAction func backAction(_ sender: Any) {
        
        if self.current > 0{
            current = current - 1
            self.downloadImage(from: URL(string: self.imageURLs[self.current])!)
        }
    }
        
    @IBAction func nextAction(_ sender: Any) {
        
        current = current + 1
        if self.current < self.imageURLs.count - 1{
            self.downloadImage(from: URL(string: self.imageURLs[self.current])!)
        }
    }
    @IBAction func previousViewAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchURLs(){
        let url = URL(string: "http://back-api.com/pingo/wallpapers/list.php")!
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request){data, response, error in
            
            if error == nil{
                do{
                    let model = try JSONDecoder().decode(urls.self, from: data!)
                    self.imageURLs = model.content
                    print(self.imageURLs.count)
                    self.downloadImage(from: URL(string: self.imageURLs[self.current])!)
                }catch{
                    print(error)
                }
                
            }
        }
        session.resume()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
       
        DispatchQueue.main.async() { [weak self] in
            self?.hud.show(in: self!.view)
        }
        
        
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
                self?.image = UIImage(data: data)
                self?.hud.dismiss()
            }
        }
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        
        let alert = UIAlertController(title: "Saved Successfully", message: "Wallpaper saved successfully", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

struct urls: Decodable {
    
    let content: [String]
}
