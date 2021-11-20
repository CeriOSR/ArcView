//
//  ArcCell.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import UIKit

class ArcCell: UICollectionViewCell {
    
    static let identifier: String = "ArcCell"
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var colorView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
}

// MARK: - Setup
extension ArcCell {
    func setupViews() {
        borderView.layer.cornerRadius = borderView.bounds.width / 2
        borderView.layer.masksToBounds = true
        colorView.layer.cornerRadius = borderView.bounds.width / 2
        colorView.layer.masksToBounds = true
    }
}
