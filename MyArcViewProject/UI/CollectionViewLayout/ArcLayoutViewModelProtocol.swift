//
//  ArcLayoutViewModelProtocol.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-20.
//

import Foundation
import CoreGraphics

protocol ArcLayoutViewModelProtocol {
    // MARK: Public
    var itemAndSpacingWidth: CGFloat { get }
    
    // MARK: Private
    var itemCount: Int { get set }
    var itemXSpacing: CGFloat { get }
    var itemSize: CGSize { get }
    // Radius of the circle that the cells will arc over - Lower for steeper arc.
    var arcRadius: CGFloat { get }
    
    // Make this large enough so a fast swipe will stop before bouncing. Needed for Looping.
    var insetWidth: CGFloat { get }
}
