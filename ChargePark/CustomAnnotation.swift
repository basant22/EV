//
//  CustomAnnotation.swift
//  ChargePark
//
//  Created by apple on 26/06/1943 Saka.
//

import Foundation
import MapKit
class CustomAnnotationView : MKPinAnnotationView
{
    let selectedLabel:UILabel = UILabel.init(frame:CGRect(x: 0, y: 0, width: 140, height: 38) )
    //let img:UIImageView = UIImageView.init(frame:CGRect(x: 0, y: 40, width: 50, height: 50) )

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(false, animated: animated)

        if(selected)
        {
            // Do customization, for example:
            selectedLabel.text = "Hello World!!"
          //  img.image = #imageLiteral(resourceName: "MapLogo")
            selectedLabel.textAlignment = .center
            selectedLabel.font = UIFont.init(name: "HelveticaBold", size: 15)
            selectedLabel.backgroundColor = UIColor.lightGray
            selectedLabel.layer.borderColor = UIColor.darkGray.cgColor
            selectedLabel.layer.borderWidth = 2
            selectedLabel.layer.cornerRadius = 5
            selectedLabel.layer.masksToBounds = true

            selectedLabel.center.x = 0.5 * self.frame.size.width;
            selectedLabel.center.y = -0.5 * selectedLabel.frame.height;
            self.addSubview(selectedLabel)
         //   self.addSubview(img)
        }
        else
        {
            selectedLabel.removeFromSuperview()
        }
    }
}
