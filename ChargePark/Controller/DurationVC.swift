//
//  DurationVC.swift
//  ChargePark
//
//  Created by apple on 31/12/21.
//

import UIKit
import RangeSeekSlider
import SwiftUI
class DurationVC: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHStack: UIStackView!
    @IBOutlet weak var rangeSelector: RangeSeekSlider!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    var complete:((Int?,UIViewController)->()) = {_,_ in}
    var outputType = ""
    var maxValue:CGFloat = 0.0
    var interval:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.55)
        self.isModalInPresentation = true
        setup()
        // Do any additional setup after loading the view.
    }
    private func setup() {
        // standard range slider
        btnClose.setTitle("", for: .normal)
        let img = UIImage(systemName: "xmark")?.tint(with: Theme.menuHeaderColor)
        btnClose.setImage(img, for: .normal)
        btnContinue.backgroundColor = Theme.menuHeaderColor
        btnContinue.cornerRadius(with: 6.0)
        btnContinue.setTitleColor(.white, for: .normal)
        viewMain.round(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12.0, color: Theme.menuHeaderColor)
        rangeSelector.delegate = self

        // currency range slider
       
        rangeSelector.minValue = 1
        rangeSelector.maxValue = CGFloat(self.maxValue)
        rangeSelector.selectedMinValue = 1
        rangeSelector.selectedMaxValue = 1
        rangeSelector.disableRange = true
        rangeSelector.enableStep = true
        rangeSelector.step = self.interval
       // rangeSliderCurrency.minDistance = 20.0
       // rangeSliderCurrency.maxDistance = 80.0
        rangeSelector.tintColor = Theme.menuHeaderColor
        rangeSelector.handleColor = Theme.newGreen
        rangeSelector.handleDiameter = 30.0
        rangeSelector.selectedHandleDiameterMultiplier = 1.3
        rangeSelector.numberFormatter.numberStyle = .decimal
        if self.outputType == "DC"{
        rangeSelector.numberFormatter.maximumFractionDigits = 2
        }
        rangeSelector.numberFormatter.locale = Locale(identifier: "en_US")
       // rangeSliderCurrency.numberFormatter.maximumFractionDigits = 2
        rangeSelector.minLabelFont = UIFont(name: "ChalkboardSE-Regular", size: 15.0)!
        rangeSelector.maxLabelFont = UIFont(name: "ChalkboardSE-Regular", size: 15.0)!

        // custom number formatter range slider
//        rangeSliderCustom.delegate = self
//        rangeSliderCustom.minValue = 0.0
//        rangeSliderCustom.maxValue = 100.0
//        rangeSliderCustom.selectedMinValue = 40.0
//        rangeSliderCustom.selectedMaxValue = 60.0
//        rangeSliderCustom.handleImage = #imageLiteral(resourceName: "custom-handle")
       // rangeSliderCustom.selectedHandleDiameterMultiplier = 1.0
       // rangeSliderCustom.colorBetweenHandles = .red
        rangeSelector.lineHeight = 5.0
      //  rangeSelector.numberFormatter.positivePrefix = "h"
        //rangeSelector.numberFormatter.negativePrefix = ""
        rangeSelector.numberFormatter.positiveSuffix = " hour"
        setupStack(type: self.outputType)
    }
    
    func setupStack(type:String){
        if type == "DC" {

            let textLabel = UILabel()
            textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            textLabel.text  = "1 hr"
            textLabel.textAlignment = .center
            
            let textLabel1 = UILabel()
            textLabel1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            textLabel1.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            textLabel1.text  = "1.5 hr"
            textLabel1.textAlignment = .center
            
            let textLabel2 = UILabel()
            textLabel2.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            textLabel2.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            textLabel2.text  = "2 hr"
            textLabel2.textAlignment = .center
            viewHStack.addArrangedSubview(textLabel)
            viewHStack.addArrangedSubview(textLabel1)
            viewHStack.addArrangedSubview(textLabel2)
        }
        if type == "AC" {
          for i in 1 ... 6{
              let textLabel = UILabel()
              textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
              textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
              textLabel.text  = "\(i) hr"
              textLabel.textAlignment = .center
              viewHStack.spacing = 0
              viewHStack.addArrangedSubview(textLabel)
           }
        }
        
    }
    @IBAction func btnContinue(_ sender: UIButton) {
        let value = Int(rangeSelector.selectedMaxValue)*60
        complete(value,self)
    }
    @IBAction func btnClose(_ sender: UIButton) {
        complete(0,self)
       // self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DurationVC:RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSelector {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        }
//        else if slider === rangeSliderCurrency {
//            print("Currency slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
//        } else if slider === rangeSliderCustom {
//            print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
//        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
