//
//  Annotation.swift
//  Annotation
//
//  Created by apple on 27/06/1943 Saka.
//

import Foundation
import UIKit

class Marker : UIView{
    class func infoWindow(stationName:String,Address:String,distance:String) -> UIView {
        let viewSuper:Card = Card(frame: CGRect(x: 50, y: 88, width: 200, height: 76))
            //UIView(frame: CGRect(x: 50, y: 88, width: 200, height: 76))
        let x:Int = Int(viewSuper.frame.width - 28)
        // View Right
        let viewRight:UIView = UIView(frame: CGRect(x: x, y: 0, width: 28, height: Int(viewSuper.frame.height)))
         viewRight.backgroundColor = Theme.menuHeaderColor
        viewSuper.backgroundColor = .white
        let imgArrow:UIImageView = UIImageView(frame: CGRect(x: 4, y: 25, width: 20, height: 20))
        imgArrow.image = #imageLiteral(resourceName: "RightArrow").tint(with: .white)
        viewRight.addSubview(imgArrow)
        // Left View
        let yForViewLeft = (viewSuper.frame.height - 48)/2
        let viewLeft:UIView = UIView(frame: CGRect(x: 5, y: yForViewLeft, width: 48, height: 48))
        viewLeft.cornerRadius(with: 22)
        viewLeft.backgroundColor = Theme.menuHeaderColor
        let imgCar:UIImageView = UIImageView(frame: CGRect(x: 13, y: 1, width: 22, height: 22))
        imgCar.image = #imageLiteral(resourceName: "Car").tint(with: .white)
        let lblDistance = UILabel(frame: CGRect(x: 0, y: 19, width: 48, height: 20))
        lblDistance.text = distance
        lblDistance.textAlignment = .center
        lblDistance.textColor = .white
        lblDistance.font = UIFont(name:"Helvetica Neue", size: 10.0)
        lblDistance.textColor = .white
        viewLeft.addSubview(imgCar)
        viewLeft.addSubview(lblDistance)
        
        let lblStation = UILabel(frame: CGRect(x: 55, y: 1, width: 115, height: 25))
        let lblMark = UILabel(frame: CGRect(x: 57, y: 25, width: 115, height: 15))
        let lblAvailable = UILabel(frame: CGRect(x: 60, y: Int(viewSuper.frame.height - 28), width: 80, height: 22))
        lblAvailable.text = "Available"
        lblAvailable.textColor = .white
        lblAvailable.backgroundColor = Theme.deepGreen
        lblAvailable.font = UIFont(name:"Helvetica Neue", size: 12.0)
         lblAvailable.cornerRadius(with: 6.0)
        lblAvailable.textAlignment = .center
        lblMark.text = Address
        lblMark.textAlignment = .left
        lblMark.font = UIFont(name:"Helvetica Neue", size: 10.0)
        lblMark.textColor = .black
        lblStation.text = stationName
        lblStation.font = UIFont(name:"Helvetica Neue", size: 13.0)
        lblStation.textColor = .black
        viewSuper.backgroundColor = .white
        viewSuper.addSubview(lblStation)
        viewSuper.addSubview(lblMark)
        viewSuper.addSubview(viewLeft)
        viewSuper.addSubview(viewRight)
        viewSuper.addSubview(lblAvailable)
        viewSuper.backgroundColor = Theme.lightGreen
        viewSuper.layer.borderWidth = 1.0
        viewSuper.layer.borderColor = Theme.menuHeaderColor.cgColor
        viewSuper.cornerRadius(with: 5.0)
        viewSuper.layer.masksToBounds = true
        return viewSuper
    }
}
