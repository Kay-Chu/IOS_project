//
//  OverlayMapView.swift
//  IOS_project
//
//  Created by KA YING CHU on 16/1/2024.
//

import SwiftUI
import MapKit
import UIKit
import CoreLocation

struct OverlayMapView : UIViewRepresentable {
    let delegate = MapViewDelegate()

    var mapView = MKMapView()
    
    let myPlace: CLLocationCoordinate2D
    let finishPlace: CLLocationCoordinate2D
    let navType: Int

    
    typealias UIViewType = MKMapView
    
    // Trying to navigate here
    var navigateAction: (() -> Void)? {
        return {
            self.navigateToLocation()
        }
    }
    
    
    @State private var isNavigating = false
    
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.delegate = delegate
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let overlayCoords = [
        CLLocationCoordinate2D(latitude: 52.40780553907607, longitude: -1.5059394062587261), CLLocationCoordinate2D(latitude: 52.407492801664205,  longitude: -1.5059762722503054), CLLocationCoordinate2D(latitude: 52.40743732934472, longitude: -1.5049546406373038), CLLocationCoordinate2D(latitude: 52.406951769053954, longitude: -1.5050126619901705),
            CLLocationCoordinate2D(latitude: 52.40693493313788, longitude: -1.5046948818117563),
            CLLocationCoordinate2D(latitude: 52.40762529141824, longitude: -1.5044745367607302),
        ]
        let overlay = MKPolygon(coordinates: overlayCoords, count: 6);
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003);
        let coord = CLLocationCoordinate2D(latitude: 52.40753425185038, longitude: -1.5048086625937545); 
        let region = MKCoordinateRegion(center: coord, span: span)
        uiView.delegate = delegate
        uiView.setRegion(region, animated: false);
        uiView.addOverlay(overlay);
        
        // Adding button
        let navigateButton = UIButton(type: .custom)
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "arrow.forward.circle.fill", withConfiguration: configuration)
        navigateButton.setImage(image, for: .normal)
        navigateButton.tintColor = .systemBlue
        navigateButton.addTarget(context.coordinator, action: #selector(Coordinator.navigate(_:)), for: .touchUpInside)
        navigateButton.frame = CGRect(x: 500, y: 500, width: 40, height: 40)
        navigateButton.center = CGPoint(x: mapView.bounds.midX, y: mapView.bounds.midY)
        navigateButton.layer.cornerRadius = 20
        navigateButton.clipsToBounds = true
        mapView.addSubview(navigateButton)
        
        
    }
    
    
    // Trying to add navigation here
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(parent: self)
        coordinator.requestLocationAuthorization()
        return coordinator
    }
    
    func centerMapOnUserLocation(_ mapView: MKMapView) {
        guard let userLocation = mapView.userLocation.location else {
            return
        }

        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    class Coordinator: NSObject, CLLocationManagerDelegate {
        let parent: OverlayMapView
        let locationManager = CLLocationManager()
        let geocoder: CLGeocoder


        init(parent: OverlayMapView) {
            self.parent = parent
            self.geocoder = CLGeocoder()
            super.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.headingFilter = 5 // Only if heading is available
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading() // Only if heading is available
        }

        func requestLocationAuthorization() {
            let authorizationStatus = locationManager.authorizationStatus
            
            if authorizationStatus == .notDetermined {
                if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil {
                    locationManager.requestWhenInUseAuthorization()
                }
                if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil {
                    locationManager.requestAlwaysAuthorization()
                }
            }
        }

        // CLLocationManagerDelegate methods
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                parent.mapView.showsUserLocation = true
                parent.mapView.userTrackingMode = .follow
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                // Use the user's location
                print("User Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Location manager failed with error: \(error.localizedDescription)")
        }
        

        
        @objc func navigate(_ sender: UIButton) {
            parent.isNavigating = true
            parent.navigateToLocation()
        }


    }
    func navigateToLocation() {
        let fromPlacemark = MKPlacemark(coordinate: myPlace)
        let toPlacemark = MKPlacemark(coordinate: finishPlace)
        let fromItem = MKMapItem(placemark: fromPlacemark)
        let toItem = MKMapItem(placemark: toPlacemark)

        let request = MKDirections.Request()
        request.source = fromItem
        request.destination = toItem
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error info: \(error.localizedDescription)")
            } else if let route = response?.routes.first {
                DispatchQueue.main.async {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    self.mapView.addOverlay(route.polyline)
                    let region = MKCoordinateRegion(route.polyline.boundingMapRect)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 5
            renderer.strokeColor = .red
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    
    
}
