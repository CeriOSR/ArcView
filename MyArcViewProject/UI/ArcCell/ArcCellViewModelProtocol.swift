//
//  ArcCellProtocol.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import Foundation
import UIKit

protocol ArcCellViewModelProtocol {
    var kBorderViewScale: CGFloat { get }
    var kColorViewScaleSmall: CGFloat { get }
    var kColorViewScaleMedium: CGFloat { get }
    
    var color: UIColor { get }
}
