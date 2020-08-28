//
//  LocationVC.swift
//  GasnOw
//
//  Created by Dev iOS on 8/23/20.
//  Copyright © 2020 Team Teklead. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
class LocationVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    private var locationManager = CLLocationManager()
     private var artworks: [Artwork] = []
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var table_depot: UITableView!{
        didSet{
            table_depot.isHidden = true
        }
    }
    var pinAnnotationView:MKPinAnnotationView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    func initialization()  {
        locationManager.delegate = self
        requestLocationAccess()
        mapView.delegate = self
        getDeopot()
        mapView.register(
            ArtworkView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.showAnnotations(mapView.annotations, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Depot List"
        addTopBarRightSideSearchItem()
        self.table_depot.tableFooterView = UIView()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.none, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialization()
    }
    
    func addTopBarRightSideSearchItem(){
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: navigationButton())]
//        self.navigationItem.rightBarButtonItems.bac
    }
    func navigationButton() -> UIButton{
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(self.showDepotList), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 42)
        button.backgroundColor = UIColor.appcustomcolor.redcolor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.setTitle("Show List", for: .normal)
        return button
    }
    @objc func showDepotList(_sender:UIButton)
    {
        if table_depot.isHidden {
            _sender.setTitle("Hide List", for: .normal)
            table_depot.isHidden = false
        }else {
            _sender.setTitle("Show List", for: .normal)
            table_depot.isHidden = true
        }
    }
    func getDeopot(){
        SharedManager.sharedInstance.showProgressHUD(on: self.view)
        let db = Firestore.firestore()
        db.collection("depot").getDocuments() { (querySnapshot, err) in
            SharedManager.sharedInstance.hideProgressHUD()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let geoPoint = document.data()["geo_location"] as? GeoPoint
                    let location = CLLocationCoordinate2D(latitude: geoPoint!.latitude, longitude: geoPoint!.longitude)
                    let artwork = Artwork(title: document.data()["depot_name"] as? String ?? "", locationName: document.data()["depot_address"] as? String ?? "", discipline: "Done", coordinate: location)
                    self.artworks.append(artwork)
                    print("\(document.documentID) => \(document.data())")
                    self.table_depot.reloadData()
                }
                self.mapView.addAnnotations(self.artworks)
            }
        }
        
    }
}

extension LocationVC {
  func mapView(
    _ mapView: MKMapView,
    annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    UIAlertController.popupAlert(title:"Alert!", message:"Are you sure, this is your final depot", actionTitles: [UIAlertController.okActionLocalized,UIAlertController.cancelActionLocalized], actions: [{action1 in
        //Save depo Address
        let address = view.annotation?.title ?? "" + ((view.annotation?.subtitle ?? "")!)
        UserDefaults.standard.setValue(address, forKey: "depo_address")
        UserDefaults.standard.synchronize()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        },{action2 in
            
        }, nil])
    }
}
extension LocationVC {


  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location = CLLocationCoordinate2D(latitude: 35.689949, longitude: 139.697576)
    let region = MKCoordinateRegion(
      center: location,
      latitudinalMeters: 50000,
      longitudinalMeters: 60000)
      mapView.setRegion(region, animated: true)
      mapView.addAnnotation(pinAnnotationView.annotation!)
  }
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           print("location manager authorization status changed")
           switch status {
           case .authorizedAlways:
               print("user allow app to get location data when app is active or in background")
           case .authorizedWhenInUse:
               print("user allow app to get location data only when app is active")
           case .denied:
               print("user tap 'disallow' on the permission dialog, cant get location data")
           case .restricted:
               print("parental control setting disallow location data")
           case .notDetermined:
               print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
           }
       }
}
extension LocationVC {
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: "CELL")
        }
        let object = artworks[indexPath.row]
        cell!.detailTextLabel?.text = object.subtitle
        cell!.textLabel?.text = object.title
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           UIAlertController.popupAlert(title:"Alert!", message:"Are you sure this is your final depot", actionTitles: [UIAlertController.okActionLocalized,UIAlertController.cancelActionLocalized], actions: [{action1 in
            self.table_depot.isHidden = true
            let address = self.artworks[indexPath.row].title ?? "" + ((self.artworks[indexPath.row].subtitle ?? "")!)
            UserDefaults.standard.setValue(address, forKey: "depo_address")
            UserDefaults.standard.synchronize()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
             self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        },{action2 in
            self.table_depot.isHidden = true
            self.navigationItem.rightBarButtonItems  = nil
            self.addTopBarRightSideSearchItem()
        }, nil])
    }
}
