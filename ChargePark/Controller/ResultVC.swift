//
//  ResultVC.swift
//  ChargePark
//
//  Created by apple on 24/11/21.
//

import UIKit
import CoreLocation
import GooglePlaces
protocol ResultVCDlegate:AnyObject{
    func didSelectPlace(with coordinate:CLLocationCoordinate2D)
}
class ResultVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
   
    weak var delegate:ResultVCDlegate?
   private let tableView:UITableView = {
       let tableView = UITableView()
       tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       return tableView
    }()
    private var places:[Place] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func update(with place:[Place]){
        self.tableView.isHidden = false
        self.places = place
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        let place  =  places[indexPath.row]
        GooglePlaceManager.shared.resolveLocation(for:place){[weak self] result in
            switch result {
            case .success(let cordinate):
                DispatchQueue.main.async{
                self?.delegate?.didSelectPlace(with: cordinate)
                }
            case .failure(let fail):
                print(fail)
           
            }
        }
    }
}
