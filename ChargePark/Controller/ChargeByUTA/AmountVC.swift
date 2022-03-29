//
//  AmountVC.swift
//  StartEVCharge
//
//  Created by Admin on 22/03/22.
//

import UIKit
import RangeSeekSlider
import RangeSeekSlider
class AmountVC: UIViewController {
    @IBOutlet weak var viewRange: RangeSeekSlider!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblEstmPrice: UILabel!
    @IBOutlet weak var lblSelectedAmount: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    var chargerDetail:ResultCharger?
    var pricePerUnit = 0.0
    var selectedAmount = 0
    private var tab:UtaTabController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.85)
        // Do any additional setup after loading the view.
        if let price = chargerDetail?.price{
            pricePerUnit = price
        }
        self.lblMin.text = Theme.INRSign + " 0"
        self.lblMax.text = Theme.INRSign + " 500"
        tab = tabBarController as? UtaTabController
        btnContinue.setTitle("Continue", for: .normal)
        btnContinue.setTitleColor(.white, for: .normal)
        btnContinue.backgroundColor = Theme.menuHeaderColor
        btnContinue.cornerRadius(with: 6.0)
        viewBase.cornerRadiusWitBorder(with: 12.0, border: Theme.menuHeaderColor)
        setupSlider()
    }
    fileprivate func setupSlider(){
        viewRange.delegate = self
        viewRange.minValue = 0
        viewRange.maxValue = 500
        viewRange.selectedMaxValue = 0
        viewRange.backgroundColor = .systemGray5
        viewRange.tintColor = Theme.menuHeaderColor
        viewRange.handleColor = Theme.newGreen
        viewRange.handleDiameter = 26.0
        viewRange.lineHeight = 3.0
        //viewRange.numberFormatter.numberStyle = .currency
       // viewRange.numberFormatter.locale = Locale(identifier: "en_US")
        viewRange.numberFormatter.positivePrefix = Theme.INRSign
       // viewRange.numberFormatter.positiveSuffix = " Rupees"
       
        self.lblSelectedAmount.text = Theme.INRSign  + "0"
        self.lblEstmPrice.text = Theme.INRSign  + "0"
    }
    @IBAction func btnContinue(_ sender:UIButton){
        if viewRange.selectedMaxValue == 0 {
        self.displayAlert(alertMessage: "Please select amount grater than 0")
        }else{
            let unit = viewRange.selectedMaxValue / pricePerUnit
            if let vc = tab{
                vc.doneSelection("AMOUNT",0,unit,self)
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
extension AmountVC:RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === viewRange {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            if let intValuee =  Formater.numberFormatter.string(from: maxValue as NSNumber),let intValue = Int(intValuee){
                //let intValue = Int(floor(maxValue))
              
                selectedAmount = intValue
                self.lblSelectedAmount.text = Theme.INRSign +  " \(String(describing: intValue))"
                self.lblEstmPrice.text = Theme.INRSign +  " \(String(describing: intValue))"
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
