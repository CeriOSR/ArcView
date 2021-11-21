//
//  ArcCell.swift
//  MyArcViewProject
//
//  Created by Rey Cerio on 2021-11-19.
//

import UIKit

enum CellPosition {
    case center, letToCenter, rightToCenter, farRight, farLeft
}

class ArcCell: UICollectionViewCell {
    
    static let identifier: String = "ArcCell"
    var viewModel: ArcCellViewModelProtocol!
    
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
        colorView.backgroundColor = viewModel.color
        borderView.layer.cornerRadius = borderView.bounds.width / 2
        borderView.layer.masksToBounds = true
        colorView.layer.cornerRadius = colorView.bounds.width / 2
        colorView.layer.masksToBounds = true
    }
}

// MARK: - Scale Function
extension ArcCell {
    func rescaleCellViews(in cellPosition: CellPosition) {
        
        switch cellPosition {
        
        case .center:
            animateScaling(
                of: borderView,
                and: colorView
            )
        case .letToCenter:
            animateScaling(
                of: borderView,
                with: viewModel.kBorderViewScale,
                and: colorView,
                with: viewModel.kColorViewScaleMedium
            )
            
        case .rightToCenter:
            animateScaling(
                of: borderView,
                with: viewModel.kBorderViewScale,
                and: colorView,
                with: viewModel.kColorViewScaleMedium
            )
        case .farRight:
            animateScaling(
                of: borderView,
                with: viewModel.kBorderViewScale,
                and: colorView,
                with: viewModel.kColorViewScaleSmall
            )
        
        case .farLeft:
            animateScaling(
                of: borderView,
                with: viewModel.kBorderViewScale,
                and: colorView,
                with: viewModel.kColorViewScaleSmall
            )
        }
    }        
}

private extension ArcCell {
    private func animateScaling(
        of borderView: UIView,
        with borderConstant: CGFloat? = nil,
        and colorView: UIView,
        with colorConstant: CGFloat? = nil
    ) {
        
        var colorViewTransform = CGAffineTransform.identity
        var borderViewTransform = CGAffineTransform.identity
        
        if let borderConstant = borderConstant, let colorConstant = colorConstant {
            colorViewTransform = CGAffineTransform(scaleX: colorConstant, y: colorConstant)
            borderViewTransform = CGAffineTransform(scaleX: borderConstant, y: borderConstant)
        }
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.colorView.transform = colorViewTransform
            self.borderView.transform = borderViewTransform
        }
    }
}
