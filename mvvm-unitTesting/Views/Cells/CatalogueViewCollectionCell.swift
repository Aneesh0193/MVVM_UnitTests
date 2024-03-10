//
//  CatalogueViewCollectionCell.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 09/03/24.
//

import Foundation
import UIKit


//MARK: - CatalogueViewCollectionViewCell
class CatalogueViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet var wishListed: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    
    //MARK: - ConfigureWithProduct
    func configureWithProduct(product: Product) {
        self.productName.text = product.name
        self.productPrice.text = CurrencyHelper.getMoneyString(product.price ?? 0)
        self.cellView.dropShadow(radius: 10, opacity: 0.1, color: .black)
        let placeHolderImage = UIImage(named: "placeholderImage")
        
        if let imageURL = URL(string: product.image ?? "") {
            productImage?.load(url: imageURL)
        } else {
            productImage.image = placeHolderImage
        }
    }
    
    //MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
    }
}
