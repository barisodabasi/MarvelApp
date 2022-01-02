//
//  ViewController.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 30.12.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    //MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesImage: UIImageView!
    @IBOutlet weak var favButtonAnimation: UIImageView!
    
    //MARK: - Properties
    var characterMarvel = [CharacterModel]()
    static var page = 1
    var tapGesture = UITapGestureRecognizer()
    var spinner: UIActivityIndicatorView?
    var spinnerContainer: UIView?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        response()
        tableView.delegate = self
        tableView.dataSource = self
        tapGesture.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToImage))
        favoritesImage.addGestureRecognizer(tapGesture)
        favoritesImage.isUserInteractionEnabled = true
    }
    
    @objc func tapToImage(gesture: UITapGestureRecognizer) {
        animation(favoritesImage)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func response() {
        let offset = ViewController.page * Constants.limit
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5.MD5Hex(data: MD5.MD5(string: ts + Constants.privateKey + Constants.publicKey)).lowercased()
        let url = "https://gateway.marvel.com:443/v1/public/characters?ts=\(ts)&apikey=\(Constants.publicKey)&hash=\(hash)&limit=30&offset=\(offset)"
        
        let header: HTTPHeaders = [
          "ts" : ts,
          "hash" : MD5.MD5Hex(data: MD5.MD5(string: ts + Constants.privateKey + Constants.publicKey)).lowercased(),
          "apikey" : Constants.publicKey,
          "limit" : String(Constants.limit),
          "offset" : String(ViewController.page * Constants.limit)
        ]
        showIndicator()
        AF.request(url, headers: header).response { [self] response in
            hideIndicator()
            debugPrint(response)
            switch response.result {
            case .success(let jsonResult):
                print("character Response : \(jsonResult!)")
                do{
                    let character = try JSONDecoder().decode(CharacterDataWrapper.self, from: try JSON(jsonResult!).rawData())
                    characterMarvel.append(contentsOf: (character.data?.results)!)
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
    
    func showIndicator(){
        spinnerContainer = UIView.init(frame: self.view.frame)
        spinnerContainer!.center = self.view.center
        spinnerContainer!.backgroundColor = .init(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.view.addSubview(spinnerContainer!)
        
        spinner = UIActivityIndicatorView.init(style: .large)
        spinner!.center = spinnerContainer!.center
        spinner?.color = .white
        spinnerContainer!.addSubview(spinner!)
        
        spinner!.startAnimating()
    }
    
    func hideIndicator(){
        spinner?.removeFromSuperview()
        spinnerContainer?.removeFromSuperview()
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
        return characterMarvel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let count = characterMarvel.count
        let lastElement = count - 1
        if indexPath.row == lastElement {
            ViewController.page += 1
            response()
        }
            
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarvelTableViewCell", for: indexPath) as! MarvelTableViewCell
        cell.marvelNameLabel.text = characterMarvel[indexPath.row].name
        
        if let path = characterMarvel[indexPath.row].thumbnail?.path {
            let ext = characterMarvel[indexPath.row].thumbnail?.ext
            let imageData = path + "." + ext!
            let x = URL(string: imageData)
            
            cell.marvelNameImage.kf.setImage(with: x)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let selectedCharacter = characterMarvel[indexPath.row]
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
        vc.characterMarvel = selectedCharacter
        vc.characterComicList = (selectedCharacter.comics?.items)!
        vc.id = selectedCharacter.id!
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
}
