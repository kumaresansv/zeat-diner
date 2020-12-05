//
//  CitySearchViewController.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 10/6/17.
//  Copyright © 2017 Zeat. All rights reserved.
//

import UIKit
import GooglePlaces

class CitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    

    let defaultSearchPlaceholder = "Pick a City"
    var fetcher: GMSAutocompleteFetcher?
    var searchController: UISearchController?
    var searchPredictions = [GMSAutocompletePrediction]()
    
    var pickedLocation: CLLocation?
    var pickedLocationDescription: String?
    
    var dismiss: (() -> Void)?
    var dismissAndUseCurrentLocation: (() -> Void)?
    
    weak var delegate:CitySearchViewControllerDelegate?


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var poweredByGoogleView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        filter.country = "US"
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(filter: filter);
//        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
//        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        fetcher?.delegate = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        
        searchBarView.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.sizeToFit()
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.barTintColor = .black
        searchController?.searchBar.tintColor = .gray
        searchController?.searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        DispatchQueue.main.async { [unowned self] in
            self.searchController?.searchBar.becomeFirstResponder()
            self.searchController?.isActive = true
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchPredictions.count > 0) {
            poweredByGoogleView.isHidden = false
        } else {
            poweredByGoogleView.isHidden = true
        }
        return searchPredictions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
        }

        
        let row = indexPath.row
        
        cell.textLabel?.attributedText = searchPredictions[row].attributedPrimaryText;
        cell.detailTextLabel?.attributedText = searchPredictions[row].attributedSecondaryText;

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let prediction: GMSAutocompletePrediction?
        prediction = searchPredictions[row]
        pickedLocationDescription = prediction?.attributedPrimaryText.string
        
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID((prediction?.placeID)!) { [unowned self] (place, error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                self.pickedLocation = CLLocation.init(latitude: (place?.coordinate.latitude)!, longitude: (place?.coordinate.longitude)!)
                self.searchController?.dismiss(animated: true, completion: { [unowned self] in
                    self.delegate?.sendPickedLocation(pickedLocation: self.pickedLocation!, pickedLocationDescription: self.pickedLocationDescription!)
                })
            }
        }
    }
    
    @IBAction func useCurrentLocation(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.searchController?.dismiss(animated: false, completion: { [unowned self] in
                self.dismissAndUseCurrentLocation!()
            })
            
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

}

extension CitySearchViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        searchPredictions = predictions
        
        
        self.tableView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
//        resultText?.text = error.localizedDescription
    }
    
}

extension CitySearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text!)
        print("See value Above")
        fetcher?.sourceTextHasChanged(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss!();
    }
    
}


protocol CitySearchViewControllerDelegate :class {
    func sendPickedLocation(pickedLocation location: CLLocation, pickedLocationDescription description: String)
}

