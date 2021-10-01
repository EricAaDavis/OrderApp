//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Eric Davis on 29/09/2021.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailedTextLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    let menuItem: MenuItem
    
    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(menuItem.name)
        // Do any additional setup after loading the view.
        addToOrderButton.layer.cornerRadius = 5.0
        updateUI()
    }
    
    func updateUI() {
        nameLabel.text = menuItem.name
        priceLabel.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        detailedTextLabel.text = menuItem.description
    }
    
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.1, options: [], animations: {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
