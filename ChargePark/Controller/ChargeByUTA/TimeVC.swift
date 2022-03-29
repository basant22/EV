//
//  TimeVC.swift
//  StartEVCharge
//
//  Created by Admin on 22/03/22.
//

import UIKit
import RangeSeekSlider

class TimeVC: UIViewController {
    @IBOutlet weak var viewRange: RangeSeekSlider!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var btncontinue: UIButton!
    @IBOutlet weak var lblSelectedTime: UILabel!
    @IBOutlet weak var lblEstmPrice: UILabel!
    @IBOutlet weak var viewHStack: UIStackView!
    var pricePerMin = 0.0
    var selectedTime = 0
    var chargerDetail:ResultCharger?
    var outputType = ""
    private var tab:UtaTabController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.85)
        // Do any additional setup after loading the view.
        if let price = chargerDetail?.pricePerMinute{
            pricePerMin = price
        }
        if let type = chargerDetail?.outputType{
            outputType = type
        }
        
        tab = tabBarController as? UtaTabController
        btncontinue.setTitle("Continue", for: .normal)
        btncontinue.setTitleColor(.white, for: .normal)
        btncontinue.backgroundColor = Theme.menuHeaderColor
        btncontinue.cornerRadius(with: 6.0)
        viewBase.cornerRadiusWitBorder(with: 12.0, border: Theme.menuHeaderColor)
        setupSlider()
    }
    fileprivate func setupSlider(){
        viewRange.delegate = self
        viewRange.minValue = 1
        if outputType == "DC" {
            viewRange.maxValue = 2
        }else if outputType == "AC" {
            viewRange.maxValue = 6
        }
        
        viewRange.selectedMaxValue = 1
        viewRange.backgroundColor = .systemGray5
        viewRange.tintColor = Theme.menuHeaderColor
        viewRange.handleColor = Theme.newGreen
        viewRange.handleDiameter = 26.0
        viewRange.lineHeight = 3.0
        viewRange.numberFormatter.positiveSuffix = " hour"
        if outputType == "DC" {
            viewRange.enableStep = true
            viewRange.step = 0.5
            viewRange.numberFormatter.maximumFractionDigits = 2
        }else if outputType == "AC" {
            viewRange.step = 1
        }
        
        if let intValuee = Formater.numberFormatter.string(from: viewRange.selectedMaxValue as NSNumber),let intValue = Int(intValuee){
            selectedTime = intValue
            let val = pricePerMin * Double(intValue*60)
            self.lblEstmPrice.text = Theme.INRSign  + String(format:" %.02f",val )
            self.lblSelectedTime.text = "\(intValue)" + " hour"
        }
        setupStack()
    }
    func setupStack(){
        if outputType == "DC" {

            let textLabel = UILabel()
            textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            textLabel.heightAnchor.constraint(equalToConstant: 38.0).isActive = true
            textLabel.text  = "1 hr"
            textLabel.textAlignment = .center
            
            let textLabel1 = UILabel()
            textLabel1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            textLabel1.heightAnchor.constraint(equalToConstant: 38.0).isActive = true
            textLabel1.text  = "1.5 hr"
            textLabel1.textAlignment = .center
            
            let textLabel2 = UILabel()
            textLabel2.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            textLabel2.heightAnchor.constraint(equalToConstant: 38.0).isActive = true
            textLabel2.text  = "2 hr"
            textLabel2.textAlignment = .center
            viewHStack.addArrangedSubview(textLabel)
            viewHStack.addArrangedSubview(textLabel1)
            viewHStack.addArrangedSubview(textLabel2)
        }
        if outputType == "AC" {
          for i in 1 ... 6{
              let textLabel = UILabel()
              textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
              textLabel.heightAnchor.constraint(equalToConstant: 38.0).isActive = true
              textLabel.text  = "\(i) hr"
              textLabel.textAlignment = .center
              viewHStack.spacing = 0
              viewHStack.addArrangedSubview(textLabel)
           }
        }
        
    }
    @IBAction func btnContinue(_ sender:UIButton){
        if viewRange.selectedMaxValue == 0 {
        self.displayAlert(alertMessage: "Please select hour grater than 0")
        }else{
            if let vc = tab{
                vc.doneSelection("TIME",selectedTime,0,self)
            }
        }
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
extension TimeVC:RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === viewRange {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            //let intValuePrice = Int(ceil(value))
            if let intValuee = Formater.numberFormatter.string(from: maxValue as NSNumber),let intValue = Int(intValuee){
                //let intValue = Int(floor(maxValue))
                 selectedTime = intValue
                let value = pricePerMin * maxValue*60
                //let intValuePrice = Int(ceil(value))
                self.lblEstmPrice.text = Theme.INRSign + String(format:" %.02f",value )
           // let f = 10.51
           // let y = Int(ceil(f))
               
                self.lblSelectedTime.text = "\(intValue) hour"
            }
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
