//
//  FirstViewController.swift
//  tourApplication
//
//  Created by Jaime Achircano on 2020-01-17.
//  Copyright © 2020 Jaime Achircano. All rights reserved.
//

import UIKit
import TLPhotoPicker
import GooglePlaces
import GooglePlacePicker


class FirstViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, TLPhotosPickerViewControllerDelegate, CLLocationManagerDelegate, GMSPlacePickerViewControllerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var placesClient: GMSPlacesClient!
    

    @IBOutlet weak var titleTF: UITextField!
    
    // variables for map
    var longitude = Double()
    var latitude = Double()
    
    
    var selectedThumbnail = [TLPHAsset]()
    var selectedAssests = [TLPHAsset]()
    
    
    @IBOutlet weak var typeTF: UITextField!
    let types = ["Hotels", "Malls"]
    let typePV = UIPickerView()
    
    
    @IBOutlet weak var descriptionTV: UITextView!
    
    @IBAction func CoordinationsBtn(_ sender: UIButton) {
        chooseLocation()
       }
    
    
    @IBAction func thumbnailBtn(_ sender: UIButton) {
        let viewController = TLPhotosPickerViewController ()
        
        viewController.configure.maxSelectedAssets = 1
        viewController.delegate = self
        
        viewController.selectedAssets = self.selectedThumbnail
                
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func imageBtn(_ sender: UIButton) {
        let viewController = TLPhotosPickerViewController()
        
        viewController.delegate = self
        
        viewController.selectedAssets = self.selectedAssests
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        typeTF.tag = 1
        typePV.tag = 1
        
        typePV.delegate = self
        typePV.dataSource = self
        
        typeTF.inputView = typePV
        typeTF.delegate = self
        
        descriptionTV.delegate = self
        descriptionTV.text = "Description"
        descriptionTV.textColor = UIColor.lightGray
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        placesClient = GSMPlacesClient.shared()
        
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            currentLocation = locationManager.location
        }
        
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        self.longitude = place.coordinate.longitude
        self.latitude = place.coordinate.latitude
        
    }
    
    public func chooseLocation() {
        let center = CLLocationCoordinate2D (latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
        let northEast = CLLocationCoordinate2D (latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southEast = CLLocationCoordinate2D (latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        
        let viewimport = GMSCoordinateBounds(coordinate: northEast, coordinate: southEast)
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        placePicker.delegate = self
        placePicker.modalPresentationStyle = .popover
        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return types.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return types[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            typeTF.text = types [row]
        default:
            break
        }
        self.view.endEditing(false)
    }

}

