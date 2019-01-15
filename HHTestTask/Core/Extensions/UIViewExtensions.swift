//
//  UIExtensions.swift
//  HHTestTask
//
//  Created by Maxim Tolstikov on 15/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import UIKit

@IBDesignable extension UIView {
    
    typealias Value = CGFloat
    typealias Corner = CACornerMask
    
    // MARK: - Radius
    
    /// Радиус скругления `UIView`
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
}
