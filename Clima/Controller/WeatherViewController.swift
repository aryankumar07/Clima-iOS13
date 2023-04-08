//
//  ViewController.swift
//  Clima
//
//  Created by aryan on 01/01/2023.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    let locationManager=CLLocationManager()
    
    
    var weathermanager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weathermanager.delegate=self
        searchTextField.delegate=self
        // Do any additional setup after loading the view.
    }
}


//MARK: - UItextfielddelegate

extension WeatherViewController:UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text  != ""{
            return true
        }
        else{
            searchTextField.placeholder="type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weathermanager.fetchWeather(cityName: city)
        }
        
        searchTextField.text=""
    }
    
}

//MARK: - weathermanagerdealgate

extension WeatherViewController:weatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text=weather.temperatureString
            self.conditionImageView.image=UIImage(systemName: weather.conditionName)
            self.cityLabel.text=weather.CityName
        }
        print(weather.temperatureString)
    }
    
    func didFailWithError(eroor: Error) {
        print(eroor )
    }
    
}

//MARK: - loactionmanagerdelegate

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got your loaction")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error)
    }
    
}

 
