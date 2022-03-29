//
//  SocVC.swift
//  ChargePark
//
//  Created by apple on 23/03/22.
//

import UIKit
import RangeSeekSlider
class SocVC: UIViewController {
    @IBOutlet weak var viewRange: RangeSeekSlider!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var btncontinue: UIButton!
    @IBOutlet weak var lblSelectedSoc: UILabel!
    var pricePerUnit:Double = 0.0
    var selectedUnit = 0
    private var tab:UtaTabController?
    var chargerDetail:ResultCharger?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.85)
        // Do any additional setup after loading the view.
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
        viewRange.minValue = 0
        viewRange.maxValue = 100
        viewRange.selectedMaxValue = 0
        viewRange.backgroundColor = .systemGray5
        viewRange.tintColor = Theme.menuHeaderColor
        viewRange.handleColor = Theme.newGreen
        viewRange.handleDiameter = 26.0
        viewRange.lineHeight = 3.0
        viewRange.numberFormatter.positiveSuffix = " %"
        self.lblSelectedSoc.text = "0 %"
    }
    @IBAction func btnContinue(_ sender:UIButton){
        if viewRange.selectedMaxValue == 0 {
        self.displayAlert(alertMessage: "Please select SOC grater than 0")
        }else{
            if let vc = tab{
                vc.doneSelection("SOC",selectedUnit,0,self)
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
extension SocVC:RangeSeekSliderDelegate{
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === viewRange {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            if let intValuee = Formater.numberFormatter.string(from: maxValue as NSNumber),let intValue = Int(intValuee){
                //let intValue = Int(floor(maxValue))
                selectedUnit = intValue
                self.lblSelectedSoc.text = "\(intValue) %"
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
