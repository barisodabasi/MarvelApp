//
//  CharacterDetailViewController.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 1.01.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class CharacterDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
     //MARK: - UI Elements
    @IBOutlet weak var detailsHiddenView: UIView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var comicDetailsHiddenView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notFoundView: UIView!
    
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var backButtonAnimation: UIButton!
    
    //MARK: - Properties
    
    var characterMarvel = CharacterModel()
    var characterComicList = [ComicSummary]()
    var favoriteCharacters = [CharacterModel]()
    
    var characterComics = [Comic]()
    var tapGesture = UITapGestureRecognizer()
    var id = 0
    var savedChecked = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
        
        heroDetails()
        
        tapGesture.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToImage))
        favImage.addGestureRecognizer(tapGesture)
        favImage.isUserInteractionEnabled = true
    }
    
    @objc func tapToImage(gesture: UITapGestureRecognizer) {
        savedChecked = !savedChecked
        animation(favImage)
       
        
        if savedChecked == true {
            favImage.image = UIImage(named: "favicon")
            let character = [characterMarvel]
            
            let x = FavoritesViewController()
            x.favoriteCharacters.append(contentsOf: character)
            UserDefaults.standard.set(encodable: x.favoriteCharacters, forKey: "character")

        } else {
            favImage.image = UIImage(named: "notfavicon")
        }
    }

    //MARK: - Functions
   func setupUI() {
       detailsHiddenView.isHidden = false
       comicDetailsHiddenView.isHidden = true
       notFoundView.isHidden = true
       
       let path = characterMarvel.thumbnail?.path
       let ext = characterMarvel.thumbnail?.ext
       let imageData = path! + "." + ext!
       let x = URL(string: imageData)
       
       detailImageView.kf.setImage(with: x)
       
       detailNameLabel.text = characterMarvel.name
       
       if characterMarvel.description != "" {
           detailDescriptionLabel.text = characterMarvel.description
       } else {
           detailDescriptionLabel.text = "No Description Found..."
       }
       //characterComicList = characterMarvel.comics!
      // print("ComicList -> \(characterComicList)")
    }
    
    func heroDetails() {
       // var offset = ViewController.page * Constants.limit
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5.MD5Hex(data: MD5.MD5(string: ts + Constants.privateKey + Constants.publicKey)).lowercased()
        let url = "https://gateway.marvel.com:443/v1/public/characters/\(id)/comics?ts=\(ts)&apikey=\(Constants.publicKey)&hash=\(hash)&limit=10&dateRange=2005-01-01%2C2021-01-01"
       // let s = "https://gateway.marvel.com:443/v1/public/characters/1009150?startYear=2005?ts=\(ts)&apikey=\(Constants.publicKey)&hash=\(hash)"
        
        let header: HTTPHeaders = [
          "ts" : ts,
          "hash" : MD5.MD5Hex(data: MD5.MD5(string: ts + Constants.privateKey + Constants.publicKey)).lowercased(),
          "apikey" : Constants.publicKey,
          "limit" : "10",
          "offset" : String(ViewController.page * Constants.limit)
        ]
        
        AF.request(url, headers: header).response { [self] response in
            debugPrint(response)
            switch response.result {
            case .success(let jsonResult):
                print("character Response : \(jsonResult!)")
                do{
                    let character = try JSONDecoder().decode(ComicDataWrapper.self, from: try JSON(jsonResult!).rawData())
                    characterComics.append(contentsOf: (character.data.results))
                    if characterComics.isEmpty {
                        comicDetailsHiddenView.isHidden = true
                        notFoundView.isHidden = false
                    }
                    tableView.reloadData()
                    debugPrint("character:  \(character)")
                } catch let error{
                    print("character Json Parse Error : \(error)")
                }
            case .failure(let error):
                print("character Request failed with error: \(error)")
                
            }
        }
        
    }
    
    func animation(_ viewAnimate: UIView) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            viewAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
        
    }
    
    //MARK: - TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterComics.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicTableViewCell", for: indexPath) as! ComicTableViewCell
        cell.comicDescriptionLabel.text = characterComics[indexPath.row].title
        
        if let path = characterComics[indexPath.row].thumbnail?.path {
            let ext = characterComics[indexPath.row].thumbnail?.ext
            let imageData = path + "." + ext!
            let x = URL(string: imageData)
            cell.comicImageView.kf.setImage(with: x)
        }
        
        return cell
    }
 
    //MARK: - Actions
    @IBAction func segmentChangeControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            detailsHiddenView.isHidden = false
            comicDetailsHiddenView.isHidden = true
            notFoundView.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            detailsHiddenView.isHidden = true
            comicDetailsHiddenView.isHidden = false
            
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        animation(backButtonAnimation)
        dismiss(animated: true, completion: nil)
    }
  
}


extension UserDefaults {

    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }

    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
