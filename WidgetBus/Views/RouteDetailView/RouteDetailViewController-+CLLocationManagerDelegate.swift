//
//  RouteDetailViewController-+CLLocationManagerDelegate.swift
//  WidgetBus
//
//  Created by 김혜수 on 2022/12/02.
//

import Foundation
import CoreLocation

extension RouteDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate.latitude)
            print(coordinate.longitude)
            clientLocation.latitude = coordinate.latitude
            clientLocation.longtitude = coordinate.longitude
            // start 가져오고싶을때 stop / startUpdatingLocation - stopUpdatingLocation / requireLocation
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error : \(error.localizedDescription)")
    }
}

extension CLLocation {
    class func distance(clientLocation: CLLocationCoordinate2D,
                        busLocation: CLLocationCoordinate2D) -> CLLocationDistance {

        let clientLocation = CLLocation(
            latitude: clientLocation.latitude,
            longitude: clientLocation.longitude
        )
        let busLocation = CLLocation(latitude: busLocation.latitude, longitude: busLocation.longitude)

        return clientLocation.distance(from: busLocation)
    }
}
