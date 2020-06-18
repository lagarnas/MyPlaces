//
//  MapManager.swift
//  MyPlaces
//
//  Created by Анастасия Лагарникова on 09.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import MapKit

class MapManager {
    let locationManager = CLLocationManager()
    
    private var placeCoordinate: CLLocationCoordinate2D?
    
    private let regionInMeters = 1000.00
    private var directionsArray: [MKDirections] = []
    
    //Маркер заведения
    func setupPlacemark(place: Place, mapView: MKMapView) {
        
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    //Проверка доступности сервисов геолокации
    private func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAutorization(mapView: mapView, incomeSegueIdentifier: segueIdentifier)
            closure()
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your location is not Available",
                    message: "To give permission Go to: Settings - My Places - Location")
            }
        }
    }
    
    //Проверка авторизации приложения для использования скрвисов геолокации
    func checkLocationAutorization(mapView: MKMapView, incomeSegueIdentifier: String ) {
        switch CLLocationManager.authorizationStatus() {
        //разрешение при использовании приложения
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAddress" { showUserLocation(mapView: mapView) }
            break
        //приложению отказано использовать службы геолокации
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your location is not Available",
                    message: "To give permission Go to: Settings - My Places - Location")
            }
            break
        //статус не определен
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        //приложение не авторизовано для служб геолокации
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your location is not Available",
                    message: "To give permission Go to: Settings - My Places - Location")
            }
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("new case is avaliable")
        }
    }
    
    //Фокус карты на местоположение пользователя
    func showUserLocation(mapView: MKMapView) {
           if let location = locationManager.location?.coordinate {
               let region = MKCoordinateRegion(center: location,
                                               latitudinalMeters: regionInMeters,
                                               longitudinalMeters: regionInMeters)
               mapView.setRegion(region, animated: true)
           }
    }
    
    //Строим маршрут от метсоположения пользоватея
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(with: directions, mapView: mapView)
        
        directions.calculate { (response, error) in
            
            if error != nil {
                print("Error")
                return
            }
            guard let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available")
                return
            }
            
            response.routes.forEach {
                mapView.addOverlay($0.polyline)
                mapView.setVisibleMapRect($0.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", $0.distance / 1000)
                let timeInterval = $0.expectedTravelTime / 60
                print("Расстояние до места: \(distance) км")
                print("Время в пути состоавит \(timeInterval) минут")
            }
        }
    }
    
    //Настройка запроса для расчета маршрута
    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    //Сброс всех ранее построенных маршрутов перед построением нового
    func startTrackingUserLocation(for mapView: MKMapView, and previousLocation: CLLocation? , closure: (_ currentLocation: CLLocation) -> ()) {
        
        guard let previousLocation = previousLocation else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previousLocation) > 50 else { return }
        
        closure(center)
        
    }
    
    //Сброс всех ранее построенных маршрутов перед построением нового
    private func resetMapView(with newDirections: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(newDirections)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    //Определение центра отображаемой области карты
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
          
          let latitude = mapView.centerCoordinate.latitude
          let longitude = mapView.centerCoordinate.longitude
          
          return CLLocation(latitude: latitude, longitude: longitude)
      }
    
    

    

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
        
    }
    
}
