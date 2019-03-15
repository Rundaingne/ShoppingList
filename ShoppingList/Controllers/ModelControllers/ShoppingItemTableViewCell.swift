//
//  ShoppingItemTableViewCell.swift
//  ShoppingList
//
//  Created by Brooke Kumpunen on 3/15/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

//Let's make a protocol for the ShoppingItemTableViewCell.
protocol ShoppingItemTableViewCellDelegate: class {
    func buttonCellButtonTapped(cell: ShoppingItemTableViewCell)
}

class ShoppingItemTableViewCell: UITableViewCell {
    
    //MARK: - Delegate and landing pads
    weak var delegate: ShoppingItemTableViewCellDelegate?
    //Anytime I pass data from the delegate to here, I need to have somewhere for it to land. This is the shared instance, let's make somewhere for the data to land as well.
    
    var shoppingItem: ShoppingItem? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: Outlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var buttonImage: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Methods
    func updateViews() {
        //When information gets passed to the cell, it needs to update the nameLabel.
        guard let shoppingItem = shoppingItem else {return}
        itemNameLabel.text = shoppingItem.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: Actions
    
    @IBAction func cellButtonTapped(_ sender: UIButton) {
        delegate?.buttonCellButtonTapped(cell: self)
        //Alright, when I tap this button, all that needs to happen is the image needs to change. That is it.
    }
    
    
}
