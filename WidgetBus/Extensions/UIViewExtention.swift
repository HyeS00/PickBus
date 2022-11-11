//
//  UIViewExtention.swift
//  WidgetBus
//
//  Created by 김혜수 on 2022/11/12.
//

import Foundation
import UIKit

@IBDesignable
class UIViewExtension: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
