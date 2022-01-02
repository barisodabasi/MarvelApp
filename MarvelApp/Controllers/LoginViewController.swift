//
//  LoginViewController.swift
//  MarvelApp
//
//  Created by BarisOdabasi on 2.01.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var contınueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func contınueButtonTapped(_ sender: Any) {
        self.animation(contınueButton)
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
    
}
