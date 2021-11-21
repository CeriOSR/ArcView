//
//  ArcControllerViewModel.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import Foundation
import UIKit

class ArcControllerViewModel: ArcControllerViewModelProtocol {
    
    var midIndex: Int = 0
    var colors: [UIColor]
    
    init() {
        self.colors = [
            .brown,
            .blue,
            .black,
            .cyan,
            .green,
            .magenta,
            .purple,
            .systemPink,
            .systemIndigo,
            .systemOrange,
            .systemRed,
            .systemTeal,
            .systemYellow,
            .systemGray,
            .systemGray2,
            .systemGray3,
            .systemGray4,
            .systemGray5,
            .systemGray6,
            .white
        ]
    }
}
