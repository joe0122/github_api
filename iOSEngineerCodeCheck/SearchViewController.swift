//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by _ on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
            
    var repositoryArray = [[String:Any]]()
    
    var index: Int?
    
    var ActivityIndicator: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.placeholder = "Enter the repository name"
        searchBar.delegate = self
        
        //レイアウトの統一のためライトモードのみに設定
        self.overrideUserInterfaceStyle = .light
        
        //インディケーターの作成
        makeIndicator(view: view)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBarが空でない場合、isAlpanumericは半角英数字かの判定のextension
        if let word = searchBar.text{
            var url = "https://api.github.com/search/repositories?q=\(word)"
            url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            if UIApplication.shared.canOpenURL(URL(string: url)!){
                //ActivityIndicatorを表示
                startAnimation(view: view)
                
                URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] (data, response, error) in
                    //errorに値が入った場合
                    if error != nil{
                        //エラー内容をはく
                        print(error.debugDescription)
                        //プログラムを止める
                        return
                    }
                    //JSONで値がとってこれた場合
                    if let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any], let items = object["items"] as? [[String: Any]]{
                        self?.repositoryArray = items
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        //ActivityIndicatorを非表示
                        self?.stopAnimation()
                        self?.tableView.reloadData()
                    }
                }.resume()
            }
        }
        searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //DetailVCに画面遷移するとき
        if segue.identifier == "Detail", let detailVC = segue.destination as? RepositoryViewController{
            //タップしたセルに対応したリポジトリ情報をdetailVCに渡す
            let repository = repositoryArray[index!]
            
            detailVC.repository = ItemData(
                
                name: repository["name"] as? String ?? "Not Found",
                language: repository["language"] as? String ?? "Not Found",
                stars: repository["stargazers_count"] as? Int ?? 0,
                watchers: repository["watchers_count"] as? Int ?? 0,
                forks: repository["forks_count"] as? Int ?? 0,
                issues: repository["open_issues_count"] as? Int ?? 0,
                url: repository["svn_url"] as? String ?? "https://github.com/")
            
            let owner = repository["owner"] as? [String: Any]
            
            detailVC.owner = OwnerData(
                name: owner?["login"] as? String ?? "Not Found",
                imageURL: owner?["avatar_url"] as? String ?? "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage_%E3%83%92%E3%82%9A%E3%82%AF%E3%83%88-760x460.png")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        let repository = repositoryArray[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? "Not Found"
        cell.detailTextLabel?.text = repository["language"] as? String ?? "Not Found"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたindex番号をindexに代入
        index = indexPath.row
        //画面遷移
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
    func makeIndicator(view: UIView){
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = view.center
        ActivityIndicator.hidesWhenStopped = true
        view.addSubview(ActivityIndicator)
    }
    
    func startAnimation(view: UIView){
        ActivityIndicator.startAnimating()
    }
    
    func stopAnimation(){
        ActivityIndicator.stopAnimating()
    }
    
}
