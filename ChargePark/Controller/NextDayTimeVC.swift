//
//  NextDayTimeVC.swift
//  ChargePark
//
//  Created by apple on 30/12/21.
//

import UIKit

class NextDayTimeVC: UIViewController {
    @IBOutlet weak var viewUp:UIView!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var lblStationName:UILabel!
    @IBOutlet weak var lblStationAddress:UILabel!
    @IBOutlet weak var lblHeading:UILabel!
    @IBOutlet weak var btnClose:UIButton!
    @IBOutlet weak var btnClear:UIButton!
    @IBOutlet weak var btnDatePicker:UIButton!
    @IBOutlet weak var btnDone:UIButton!
    @IBOutlet weak var heightButton: NSLayoutConstraint!
    var stationDetail:ResultStation?
    private var tbvc : TabController?
    var dataSource = [(String,Bool,Bool,Int)]()
    var selectedDate:Date!
    var arrSelectedIndex = [Int]() // This is selected cell Index array
    var arrSelectedData = [(String,Bool,Bool,Int)]()
    var selectecSlots = [String]()
    var doneSelection:(([Int],String,UIViewController)->()) = {_,_,_ in}
    lazy var datePicker: GMDatePicker = {
        let dPicker = GMDatePicker()
        return dPicker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDatePicker.setTitle("", for: .normal)
        let img = UIImage(named: "Calander")
        btnDatePicker.setImage(img?.tint(with: .white), for: .normal)
        tbvc = tabBarController as? TabController
        collView.register(TimeSlotCell.nib(), forCellWithReuseIdentifier: TimeSlotCell.identifier)
      //  let nibHeader = UINib(nibName: "HeaderReusableView", bundle: nil)
        collView.allowsMultipleSelection = true
        collView.register(TimeSlotReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TimeSlotReusableView.identifier)
//        let layout = self.collView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.headerReferenceSize = CGSize(width: self.collView.frame.size.width, height: 100)
//        if let station = stationDetail {
//            lblStationAddress.text = station.address
//        }
//        if let station = stationDetail {
//            lblStationName.text = "Available Time Slots"
//            //station.stationname
//        }
        lblStationName.text = "Available Time Slots"
        lblStationName.textColor = .white
        lblStationAddress.textColor = .white
        lblHeading.textColor = .white
        lblHeading.text = "Date: " + Date().add(Day: 1).toddMMMyyString()
        btnClose.setTitle("", for: .normal)
        let imgg = UIImage(systemName: "xmark")?.tint(with: .white)
        btnClose.setImage(imgg, for: .normal)
        viewUp.backgroundColor = Theme.menuHeaderColor
        btnDone.backgroundColor = Theme.menuHeaderColor
        self.showHideBtnContinue(showHide: true)
        // Do any additional setup after loading the view.
    }
    
    func addRemoveSelectedData(indx:Int){
        if arrSelectedIndex.count == 0 || !(arrSelectedIndex.count >= 6){
            print("You selected cell #\(indx)!")
        if dataSource[indx].2 == false {
            dataSource[indx].2 = true
            arrSelectedData.append(dataSource[indx])
            arrSelectedIndex.append(indx)
        }else{
            dataSource[indx].2 = false
            arrSelectedData = arrSelectedData.filter({$0 != dataSource[indx]})
            arrSelectedIndex = arrSelectedIndex.filter({$0 != indx})
        }
      }
    }
    func showHideBtnContinue(showHide:Bool){
        if showHide {
            UIView.animate(withDuration: 1.5) {
                self.heightButton.constant = 50
            }
        }else{
            UIView.animate(withDuration: 1.5) {
                self.heightButton.constant = 0
            }
        }
        self.view.layoutIfNeeded()
    }
    @IBAction func btnClear(_sender:UIButton){
        if (arrSelectedIndex.count >= 1){
            arrSelectedData = []
            let aa = self.dataSource.filter({$0.2 == true}).map({$0.3})
            aa.map({self.dataSource[$0].2 = false})
            self.collView.reloadData()
        }
    }
    @IBAction func closeVC(_sender:UIButton){
        if let vc = tbvc{
           // vc.dismiss(animated: true, completion: nil)
            vc.noSelection(vc)
        }
    }
    @IBAction func btnDatePicker(_sender:UIButton){
        datePicker.datePicker.minimumDate = Date().add(Day: 1)
        datePicker.datePicker.maximumDate = Date().add(Day: 30)
        datePicker.delegate = self
        datePicker.show(inVC: self, completion: nil)
    }
    
    func selecteLastTime() -> String{
        let dateTime = Date().add(Day: 1).to_yyyy_mm_dd_String()
        var dt = ""
        var dtt = ""
        if let selData = self.arrSelectedData.last,let timeStart = selData.0.components(separatedBy: "-").last{
            if self.selectedDate != nil {
                dtt = self.selectedDate.toString()
            }else{
            let dateTim = timeStart.convertDateForma()
             dt = dateTime + "T" + dateTim
             dtt = dt.toDate().toString()
            }
            print("selected date Time = \(dtt)")
        }
        return dtt
    }
    
    @IBAction func doneVC(_sender:UIButton){
        let dateTime = Date().add(Day: 1).to_yyyy_mm_dd_String()
        var dt = ""
        var dtt = ""
        if let indx = self.arrSelectedIndex.first, let timeStart = dataSource[indx].0.components(separatedBy: "-").first{
           
            //,let timeStart = selData.0.components(separatedBy: "-").first
           // print("timeStar \(timeStart)")
           // let dateTim = timeStart.converthhmmStringToDate().toString()
            if self.selectedDate != nil {
                dtt = self.selectedDate.toString()
            }else{
            let dateTim = timeStart.convertDateForma()
             dt = dateTime + "T" + dateTim
             dtt = dt.toDate().toString()
            }
            let lastTime = selecteLastTime()
            print("selected date Time = \(dtt)")
            if let vc = tbvc{
                vc.selectionComplete(self.arrSelectedIndex,dtt,lastTime,vc)
            }
        }else{
            if let vc = tbvc{
                vc.selectionComplete(nil,nil,nil,vc)
            }
        }
       
        //self.doneSelection(self.arrSelectedIndex,dateTime,self)
//        if let vc = tbvc{
//            vc.selectionComplete(self.arrSelectedIndex,dateTime,self)
//        }
    }
    deinit{
       print("\(self) is deinitilized")
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
extension NextDayTimeVC:GMDatePickerDelegate{
    func gmDatePicker(_ gmDatePicker: GMDatePicker, didSelect date: Date) {
        print(date)
        self.selectedDate = date
        lblHeading.text = "Date: " + self.selectedDate.toddMMMyyString()
        print(lblHeading.text ?? "")
    }
    
    func gmDatePickerDidCancelSelection(_ gmDatePicker: GMDatePicker) {
        
    }
    
}
extension NextDayTimeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return dataSource.count
    //    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return dataSource[section].count
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! TimeSlotCell
        // let data = dataSource[indexPath.section]
        cell.setupCellData(data: dataSource[indexPath.item])
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    //        let cg = collectionView.bounds.size.width / 3.0
    //        return CGSize(width: cg, height:65)
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let yourWidth = collectionView.bounds.width / 3.0
        let yourHeight = 70.0
        return CGSize(width: yourWidth, height:yourHeight)
        // return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        let strData = dataSource[indexPath.item]
        let indx = indexPath.item
        addRemoveSelectedData(indx: indx)
        
        if (arrSelectedIndex.count > 1) && !(arrSelectedIndex.count >= 6) {
            arrSelectedIndex.sort()
            let consecutives = arrSelectedIndex.map { $0 - 1 }.dropFirst() == arrSelectedIndex.dropLast()
            if consecutives {
                self.collView.reloadData()
                self.showHideBtnContinue(showHide: true)
            }else{
                //dataSource[indx].2 = false
                
                let aa = self.dataSource.filter({$0.2 == true}).map({$0.3})
                aa.map({self.dataSource[$0].2 = false})
               // dataSource.map({})
                dataSource[indx].2 = true
                arrSelectedData = []
                arrSelectedData.append(self.dataSource[indx])
                arrSelectedIndex = []
                arrSelectedIndex.append(indx)
                self.collView.reloadData()
               // arrSelectedData = arrSelectedData.filter({$0 != strData})
               // arrSelectedIndex = arrSelectedIndex.filter({$0 != indx})
                if arrSelectedIndex.count == 0 {
                    self.showHideBtnContinue(showHide: false)
                }
            }
        }else  if (arrSelectedIndex.count == 1){
            arrSelectedData = []
            let aa = self.dataSource.filter({$0.2 == true}).map({$0.3})
            aa.map({self.dataSource[$0].2 = false})
            dataSource[indx].2 = true
            arrSelectedData.append(self.dataSource[arrSelectedIndex.first!])
            self.collView.reloadData()
            self.showHideBtnContinue(showHide: true)
        }else  if (arrSelectedIndex.count == 0){
            arrSelectedData = []
            let aa = self.dataSource.filter({$0.2 == true}).map({$0.3})
            aa.map({self.dataSource[$0].2 = false})
            self.collView.reloadData()
            self.showHideBtnContinue(showHide: false)
        }
    }
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TimeSlotReusableView.identifier, for: indexPath) as! TimeSlotReusableView
            
        // guard let typedHeaderView = headerView as? TimeSlotReusableView
            //    else { return headerView }
          headerView.configure()
          //  typedHeaderView.viewHeader.cornerRadiusWitBorder(with: 10.0, border: Theme.menuHeaderColor)
           // typedHeaderView.lblHeader.text = Date().toddMMMyyString()
           // typedHeaderView.lblHeader.textColor = Theme.menuHeaderColor
          //  headerView.backgroundColor = .clear
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.size.width, height: 80.0)
    }*/
    
}
