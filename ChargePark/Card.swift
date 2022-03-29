//
//  Card.swift
//  ChargePark
//
//  Created by apple on 23/06/1943 Saka.
//

import Foundation
import UIKit
@IBDesignable

class ButtonRound:UIButton{
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 6.0
    @IBInspectable var borderColor: UIColor = Theme.menuHeaderColor
    @IBInspectable var backColor: UIColor = .clear
    @IBInspectable var titlColor: UIColor = Theme.menuHeaderColor
    override func layoutSubviews() {
        self.setTitleColor(titlColor, for: .normal)
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        self.backgroundColor = backColor
       
        layer.masksToBounds = true
    }
}


class Card: UIView {
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var cornerRadii: CGFloat = 4.0
    @IBInspectable var backgroundClr: UIColor = .white
    override func layoutSubviews() {
        layer.cornerRadius = 4
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadii)
       // self.backgroundColor = backgroundClr
        layer.masksToBounds = true
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2);
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
}
public struct Screen {
  /// Retrieves the device bounds.
  public static var bounds: CGRect {
    return UIScreen.main.bounds
  }
  
  /// Retrieves the device width.
  public static var width: CGFloat {
    return bounds.width
  }
  
  /// Retrieves the device height.
  public static var height: CGFloat {
    return bounds.height
  }
  
  /// Retrieves the device scale.
  public static var scale: CGFloat {
    return UIScreen.main.scale
  }
}
