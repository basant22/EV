//
//  CompletedBookingVC.swift
//  ChargePark
//
//  Created by apple on 09/01/22.
//

import UIKit

class CompletedBookingVC: UIViewController {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var navigation:UINavigationBar!
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var titleBar:UIBarButtonItem!
    var bookings:[Booking] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       self.tableView.backgroundColor = Theme.menuHeaderColor
        navigation.barTintColor = Theme.menuHeaderColor
        navigation.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigation.titleTextAttributes = textAttributes
        if  self.revealViewController() != nil{
                  menuButton.target = self.revealViewController()
                  menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                  menuButton.image = #imageLiteral(resourceName: "ic_menu_white").tint(with: .white)
       // self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }

        self.tableView.registerNibs(nibNames: ["MyBookingCell",EmptyCellCell.identifier])
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "invoice"{
            if let vc = segue.destination as? PdfVC,let url = sender as? URL{
                vc.pdfURL = url
            }
        }
    }
    
    func savePdf(fileName:String,bookingId:Int,completion:@escaping(Bool)->()) {
        let urls = Theme.baseUrl
        let append = "downloadpdfinvoice?bookingId=\(bookingId)"
       let urlString = urls + append
        var appN = Theme.appName
        if Theme.appName == "EV Plugin Charge" {
            appN = "EV-Plugin"
        }
        /*
        guard let url = URL(string: urlString) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()*/

            DispatchQueue.main.async {
                let url = URL(string: urlString)
                let pdfData = try? Data.init(contentsOf: url!)
               
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "\(appN)-\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    if pdfData != nil{
                        try pdfData?.write(to: actualPath, options: .atomic)
                        completion(true)
                    }else{
                        completion(false)
                    }
                    print(pdfNameFromUrl)
                    print("pdf successfully saved!")
                    DispatchQueue.main.async {
                   

//                    let activityViewController = UIActivityViewController(activityItems: [actualPath], applicationActivities: nil)
//
//                    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//                        // exclude some activity types from the list (optional)
//                    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
//                    activityViewController.isModalInPresentation = true
//                                                        // present the view controller
//                    self.present(activityViewController, animated: true, completion: nil)
                        //self.showSavedPdf(url: actualPath)
                       // self.performSegue(withIdentifier: "invoice", sender: actualPath)
                    }
                } catch {
                    print("Pdf could not be saved")
                }
               // completion(false)
            }
        }

        func showSavedPdf(url:URL) {
            let pdfViewController = PdfVC()
               pdfViewController.pdfURL = url
               present(pdfViewController, animated: false, completion: nil)
         }

    // check to avoid saving a file multiple times
    func pdfFileAlreadySaved(fileName:String)-> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(Theme.appName)-\(fileName).pdf") {
                        status = true
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return status
    }
    
}
extension CompletedBookingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookings.count > 0 ? self.bookings.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.bookings.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell", for: indexPath) as! MyBookingCell
            cell.cancelBooking = { [weak self] indexrow in
                if let bookingId = self?.bookings[indexrow].bookingID{
                   // self?.downloadInvoice(bookingId: bookingId)
                    self?.savePdf(fileName: String(bookingId), bookingId: bookingId, completion: { complte in
                        if complte {
                       // self?.bookings[indexrow].isDownloaded = true
                        self?.tableView.reloadData()
                        }else{
                            self?.displayAlert(alertMessage: "Invoice is not available")
                        }
                    })
                }
            }
            cell.showPdf = { [weak self] pdfurl in
                DispatchQueue.main.async {
                   
                   
//                    let activityViewController = UIActivityViewController(activityItems: [pdfurl], applicationActivities: nil)
//
//                    activityViewController.popoverPresentationController?.sourceView = self?.view // so that iPads won't crash
//                        // exclude some activity types from the list (optional)
//                    activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
//                    activityViewController.isModalInPresentation = true
//                                                        // present the view controller
//                    self?.present(activityViewController, animated: true, completion: nil)
                    self?.performSegue(withIdentifier: "invoice", sender: pdfurl)
                }
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCellCell.identifier, for: indexPath) as! EmptyCellCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.bookings.count > 0 {
        let cell = cell as! MyBookingCell
                cell.setCellData(data: self.bookings[indexPath.row],tag:indexPath.row)
        }else{
            let cell = cell as! EmptyCellCell
            cell.backgroundColor = Theme.menuHeaderColor
            cell.contentView.backgroundColor = Theme.menuHeaderColor
            cell.backgroundColor = Theme.menuHeaderColor
            cell.img.image =  #imageLiteral(resourceName: "My Vehicle").tint(with: .white)
            cell.lblTitle.textColor = .white
            cell.lblTitle.text = "No bookings found."
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.bookings.count > 0 {
        return 150
        }else{
            return self.tableView.bounds.size.height
        }
    }
}
extension CompletedBookingVC:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // println("download task did write data")

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

//        dispatch_async(dispatch_get_main_queue()) {
//          //  self.progressDownloadIndicator.progress = progress
//        }
        DispatchQueue.main.async {
            
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
           // self.pdfURL = destinationURL
            DispatchQueue.main.async {
                //self.showSavedPdf(url: destinationURL)
                self.performSegue(withIdentifier: "invoice", sender: destinationURL)
            }

        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
