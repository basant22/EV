//
//  TimeSlotReusableView.swift
//  ChargePark
//
//  Created by apple on 02/12/21.
//

import UIKit

class TimeSlotReusableView: UICollectionReusableView {
   static let identifier = "TimeSlotReusableView"
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.text = Date().toddMMMyyString()
        lbl.textColor = Theme.menuHeaderColor
        lbl.textAlignment = .center
        return lbl
    }()
    public func configure(){
        backgroundColor = .cyan
        addSubview(lblHeader)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lblHeader.frame = bounds
    }
}
