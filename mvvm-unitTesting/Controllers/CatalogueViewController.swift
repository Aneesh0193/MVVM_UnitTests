//
//  CatalogueViewController.swift
//  mvvm-unitTesting
//
//  Created by Aneesh on 08/03/24.
//

import Foundation
import UIKit



@available(iOS 13.0, *)
class CatalogueViewController: UIViewController {
    
    
    //Views
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activity: UIActivityIndicatorView!

    //Variables
    private var productViewModel = ProductViewModel(apiService: HttpUtility())
    
  
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupview()
    }
    
    //MARK: - Setupview
    private func setupview() {
        fetchCatalogue()
    }
   

    //MARK: - FetchCatalogue
    private func fetchCatalogue() {
        Task {
            do {
                _ = try await productViewModel.getCataLogueData()
            } catch ServiceError.DecodeError(decodeError: let error) {
                print(error)
            } catch ServiceError.InvalidResponse(invalidResponse: let message) {
                print("Invalid URL\(message)")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.refreshTableView()
            }
        }
    }
    
    //MARK: - Refresh TableView
    private func refreshTableView() {
        self.collectionView.reloadData()
        self.activity.isHidden = true
    }
}

//MARK: - Data Source and Delegate
@available(iOS 13.0, *)
extension CatalogueViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productViewModel.getNumberOfRowsInSections()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCataLogueCellIdentifier, for: indexPath) as? CatalogueViewCollectionViewCell else { return UICollectionViewCell()}
        
        guard let product = productViewModel.getData(index: indexPath.row) else { return cell }
        cell.configureWithProduct(product: product)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 250)
    }
}

