//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by _ on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SafariServices

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var wachersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
        
    @IBOutlet weak var openRepository: UIButton!
        
    var repository: ItemData?
    var owner: OwnerData?
                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = repository?.name
        ownerLabel.text = owner?.name
        languageLabel.text = "language:\(repository?.language ?? "Not Found")"
        starsLabel.text = "\(String(repository?.stars ?? 0)) stars"
        wachersLabel.text = "\(String(repository?.watchers ?? 0)) watchers"
        forksLabel.text = "\(String(repository?.forks ?? 0)) forks"
        issuesLabel.text = "\(String(repository?.issues ?? 0)) issues"
        
        addShadow(button: openRepository)
        
        //レイアウトを統一するためにライトモードに固定
        self.overrideUserInterfaceStyle = .light

        //タイトルが長い場合は文字のサイズを収まるサイズに変更
        titleLabel.adjustsFontSizeToFitWidth = true
                
        getImage()
        
    }
    
    func getImage(){
        
        //渡されてきたリポジトリのユーザーのアイコンを持ってくる
        URLSession.shared.dataTask(with: URL(string: (owner?.imageURL)!)!) { (data, response, error) in
        
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data!)
            }
        }.resume()
    }
    
    
    @IBAction func openRepositoryAction(_ sender: Any) {
        
        //リポジトリのURLが開ける場合
        if UIApplication.shared.canOpenURL(URL(string: (repository?.url)!)!){
            //SFSafariViewで開く
            let safariVC = SFSafariViewController(url: URL(string: (repository?.url!)!)!)
            present(safariVC, animated: true,completion: nil)
        
        //リポジトリのURLが開けない場合
        }else{
            //アラートを表示させる
            let alert = UIAlertController(title: "ERROR", message: " URL cannot be opened", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func addShadow(button:UIButton){
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.5
    }
    
    
    
}
