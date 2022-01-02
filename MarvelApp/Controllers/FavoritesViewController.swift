//
//  FavoritesViewController.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 1.01.2022.
//

import UIKit
import Foundation
import Kingfisher

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButtonAnimation: UIButton!
    @IBOutlet weak var noFavHiddenView: UIView!
    
    //MARK: - Properties
    var favoriteCharacters = [CharacterModel]()
   
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let userFav = UserDefaults.standard.value([CharacterModel].self, forKey: "character") {
            favoriteCharacters = userFav
            noFavHiddenView.isHidden = true
            tableView.isHidden = false
        } else {
            noFavHiddenView.isHidden = false
            tableView.isHidden = true
        }
 }
    
    //MARK: - Functions
    func animation(_ viewAnimate: UIView) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            viewAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
        
    }

    //MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        animation(backButtonAnimation)
    }
    
    //MARK: - TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        cell.favoritesNameLabel.text = favoriteCharacters[indexPath.row].name
        
        let path = favoriteCharacters[indexPath.row].thumbnail?.path!
        let ext = favoriteCharacters[indexPath.row].thumbnail?.ext!
        let imageData = path! + "." + ext!
        let x = URL(string: imageData)
        
        cell.favoritesImageView.kf.setImage(with: x)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndexPath = favoriteCharacters[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CharacterDetailViewController") as! CharacterDetailViewController
        vc.characterMarvel = selectedIndexPath
        vc.characterComicList = (selectedIndexPath.comics?.items)!
        vc.id = selectedIndexPath.id!
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
