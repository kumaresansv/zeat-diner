//
//  RestaurantListViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 9/22/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
//import GooglePlaces
import AlamofireImage
import CoreLocation
import NVActivityIndicatorView
//import NVActivityIndicatorViewExtended

class RestaurantListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CitySearchViewControllerDelegate {

    var searchFinished = false
    var currentLocationSearch = true
    let textCellIdentifier = "restaurantTableCell"
    var pickedLocationText = "Current Location"
    let defaultSearchPlaceholder = "Pick a City"

    var pickedLocation: CLLocation?
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()

    var restaurantList = [Restaurant]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .default
        // Do any additional setup after loading the view.

        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.register(UINib(nibName: "RestaurantTableCell", bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        tableView.rowHeight = 220
        tableView.separatorStyle = .none
        
        // Set Delay Content Touches to False for all scrollviews. This will
        // enable Buttons to respond quickly to touches
        for view in tableView.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
                break
            }
        }
        
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: navBar.frame.height - 1.0, width: UIScreen.main.bounds.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.init(white: 0.8, alpha: 1.0).cgColor
        navBar.layer.addSublayer(bottomBorder)
        
        self.navBarLabel.text = pickedLocationText
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let zeatNavigationController = self.navigationController as? ZeatNavigationController else {
            return
        }
        zeatNavigationController.navigationBar.barStyle = .default
        zeatNavigationController.enableMenuButton!()
        requestForLocationUse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let zeatNavigationController = self.navigationController as? ZeatNavigationController else {
            return
        }
        
        zeatNavigationController.disableMenuButton!()
        zeatNavigationController.showMenuButton!()
        zeatNavigationController.navigationBar.isHidden = true
//        zeatNavigationController.showMenuButton!()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFinished {
            return restaurantList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: RestaurantTableCell! = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as? RestaurantTableCell
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier) as? RestaurantTableCell
        }
        
        let row = indexPath.row
        let placeholderImage = UIImage(named: "RestaurantPlaceholder")!
        
        if let imageUrl = restaurantList[row].image {
            let urlRequest = URLRequest(url: URL(string: imageUrl)!)
            cell.restaurantImage.af_setImage(withURLRequest: urlRequest, placeholderImage: placeholderImage, filter: nil, completion: { (response) -> Void in
                
            })
        } else {
            cell.restaurantImage.image = placeholderImage
        }
        
        
        cell.restaurantName?.text = restaurantList[row].name
        cell.address?.text = restaurantList[row].address
        cell.distance.text = String.localizedStringWithFormat("%.2f", restaurantList[row].distance!, "mi")
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! RestaurantTableCell!
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showMenuSegue", sender: selectedCell)
        }
    }

    func searchForRestaurants() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Searching For Restaurants")

        RestaurantService.search(searchlocation: pickedLocation!, currentLocation: currentLocation!){ [weak self] result in
            
            switch result {
            case .success(let restaurantArray):
                self?.restaurantList = restaurantArray
                self?.currentLocationSearch = false
                self?.searchFinished = true
                self?.tableView.reloadData()
                
            case .failure( _):
                break
            }
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            return
        }
    }
    
    func refreshSearch() {
        if pickedLocationText == "Current Location" {
            self.currentLocationSearch = true
            self.requestForLocationUse()
        }
        else {
            searchForRestaurants()
        }
    }

    func requestForLocationUse() -> Void {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Location Usage",
                message: "Uses location to search for nearby Restuarants and confirm your presenece near a restauarant. Please open this app's settings and set location access to 'While Using the App'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        case .authorizedWhenInUse:
            if currentLocationSearch {
                let activityData = ActivityData()
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
                NVActivityIndicatorPresenter.sharedInstance.setMessage("Getting Location")
                locationManager.distanceFilter = 100.0
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        default: break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMenuSegue" {
            
            let cell = sender as! RestaurantTableCell
            let indexPath = tableView.indexPath(for: cell)
            let restaurantMenuController = segue.destination as! RestaurantMenuTableViewController
            restaurantMenuController.zeatRestaurant = self.restaurantList[(indexPath?.row)!]

//            let restaurantMenuController = segue.destination as! RestaurantMenuTableViewController
//            restaurantMenuController.hidesBottomBarWhenPushed = true
//            restaurantMenuController.dismiss = {[weak self] () in
//                self?.navigationController?.dismiss(animated: true, completion: nil)
//            }
            
        } else if segue.identifier == "searchForCity" {
            let searchCityController = segue.destination as! CitySearchViewController
            searchCityController.hidesBottomBarWhenPushed = true
            searchCityController.delegate = self
            searchCityController.dismiss = {[weak self] () in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                }
            }

            searchCityController.dismissAndUseCurrentLocation = {[weak self] () in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: { [weak self] in
                        self?.pickedLocationText = "Current Location"
                        self?.currentLocationSearch = true
                        self?.navBarLabel.text = self?.pickedLocationText
                        self?.requestForLocationUse()
                    })
                }
            }

            
        }
    }
    
    func sendPickedLocation(pickedLocation location: CLLocation, pickedLocationDescription description: String) {
        print(location)
        self.navBarLabel.text = description
        self.pickedLocation = location

        self.dismiss(animated: true) { [weak self] in
            self?.searchForRestaurants()
        }
    }
}

extension RestaurantListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if currentLocationSearch {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let loc: CLLocation = locations[locations.count - 1]
        let elapsed = Date().timeIntervalSince(loc.timestamp)
        
        if (abs(elapsed) < 15.0) {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            currentLocation = loc
            pickedLocation = loc
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            searchForRestaurants()
        }
        
        return
    }
    
}
