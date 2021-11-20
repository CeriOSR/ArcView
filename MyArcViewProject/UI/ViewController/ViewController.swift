//
//  ViewController.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backgroundColorView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Setup
extension ViewController {
    func setupViews() {
        setupCollectionView()
    }
    
    func setupCollectionView () {
        let layout = ArcCollectionViewLayout()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .yellow
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionView Delegates/datasource
extension ViewController {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArcCell.identifier,
                for: indexPath) as? ArcCell
        else { return UICollectionViewCell() }
        
        // instantiate cell and cell viewmodel here
        
        return cell
    }
}

// MARK: - ScrollView Delegates
extension ViewController {
    
}

// MARK: -
extension ViewController {
    
}

