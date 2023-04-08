//
//  WetherManager.swift
//  Clima
//
//  Created by aryan kumar on 22/03/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol weatherManagerDelegate{
    func didUpdateWeather(weather:WeatherModel)
    func didFailWithError(eroor:Error)
}

struct WeatherManager{
    
    var delegate : weatherManagerDelegate?
    
    let weatherUrl="https://api.openweathermap.org/data/2.5/weather?appid=8d5021a043dd72390f9f7c27a5b68bda&units=metric"
    
    
    
    func fetchWeather(cityName : String){
        var urlString="\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(eroor: error!)
                    return
                }
                
                if let safedata=data{
                    if let weather = parseJSON(weatherData: safedata){
                        self.delegate?.didUpdateWeather(weather:weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData:Data)->WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            let temp=decodedData.main.temp
            let Id=decodedData.weather[0].id
            let name=decodedData.name
            let weather = WeatherModel(temperatue: temp, CityName: name, conditionId: Id )
            return weather
            
        } catch{
            print(error)
            delegate?.didFailWithError(eroor: error)
            return nil
        }
    }
}
