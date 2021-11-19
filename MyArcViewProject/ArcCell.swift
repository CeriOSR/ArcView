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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
