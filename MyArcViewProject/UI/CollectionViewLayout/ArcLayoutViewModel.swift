//
//  ArcLayoutViewModel.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-20.
//

import Foundation
import CoreGraphics

class ArcLayoutViewModel: ArcLayoutViewModelProtocol {
    // MARK: Public
    var itemAndSpacingWidth: CGFloat {
        return itemSize.width + itemXSpacing
    }
    
    // MARK: Private
     var itemCount: Int = 0
    private(set) var itemXSpacing: CGFloat = 7.0   // change to 7.0 from 10 to center on stop
    private(set) var itemSize: CGSize = CGSize(width: 80, height: 80)
    // Radius of the circle that the cells will arc over - Lower for steeper arc.
    private(set) var arcRadius: CGFloat = 600
    
    // Make this large enough so a fast swipe will stop before bouncing. Needed for Looping.
    let insetWidth: CGFloat = 16000
}
