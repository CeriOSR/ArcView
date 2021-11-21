//
//  ArcCellViewModel.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import Foundation
import UIKit

class ArcCellViewModel: ArcCellViewModelProtocol {
    // Constants
    let kBorderViewScale: CGFloat = 0.3
    let kColorViewScaleSmall: CGFloat = 0.6
    let kColorViewScaleMedium: CGFloat = 0.8
    
    // variables
    var color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
}
