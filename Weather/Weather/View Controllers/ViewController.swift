//
//  ViewController.swift
//  Weather
//
//  Created by Алена on 14.12.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var imageWeatherIcon: UIImageView!
    @IBOutlet weak var temrerature: UILabel!
    @IBOutlet weak var feelsLikeTemperayre: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    var networkDataManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkDataManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWeatherWith(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
    }

    @IBAction func searchButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter the city name", message: nil, style: .alert) {[unowned self] city in
            self.networkDataManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    
    func updateInterfaceWeatherWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityName.text = weather.cityName
            self.temrerature.text = weather.temperatureString
            self.feelsLikeTemperayre.text = weather.feelsLikeTemperatureString
            self.imageWeatherIcon.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkDataManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
