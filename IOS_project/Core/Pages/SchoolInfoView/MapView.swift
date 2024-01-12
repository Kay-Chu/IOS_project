//
//  MapView.swift
//  IOS_project
//
//  Created by KA YING CHU on 23/1/2024.
//

import SwiftUI

import SwiftUI
import MapKit
import UIKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var isNavigating: Bool
    
    @Binding var myPlace: CLLocationCoordinate2D?
//    @Binding const finishPlace: CLLocationCoordinate2D?
    let finishPlace: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.40780553907607, longitude: -1.5059394062587261)
//    let finishPlace: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.330, longitude: -122.030)
    let navType: Int
    
    var defaultCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // Add navigation button
        let navigateButton = UIButton(type: .custom)
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "paperplane.circle.fill", withConfiguration: configuration)
        navigateButton.setImage(image, for: .normal)
        navigateButton.tintColor = .systemBlue
        navigateButton.addTarget(context.coordinator, action: #selector(Coordinator.navigate(_:)), for: .touchUpInside)
        navigateButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(navigateButton)
        
        // Constraints for button
        NSLayoutConstraint.activate([
            navigateButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            navigateButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            navigateButton.widthAnchor.constraint(equalToConstant: 40),
            navigateButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        navigateButton.layer.cornerRadius = 20
        navigateButton.clipsToBounds = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        let overlayCoords = [
        CLLocationCoordinate2D(latitude: 52.40780553907607, longitude: -1.5059394062587261), CLLocationCoordinate2D(latitude: 52.407492801664205,  longitude: -1.5059762722503054), CLLocationCoordinate2D(latitude: 52.40743732934472, longitude: -1.5049546406373038), CLLocationCoordinate2D(latitude: 52.406951769053954, longitude: -1.5050126619901705),
            CLLocationCoordinate2D(latitude: 52.40693493313788, longitude: -1.5046948818117563),
            CLLocationCoordinate2D(latitude: 52.40762529141824, longitude: -1.5044745367607302),
        ]
        let overlay = MKPolygon(coordinates: overlayCoords, count: overlayCoords.count)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: myPlace ?? defaultCoordinate, span: span)
        uiView.removeOverlays(uiView.overlays) // Remove previous overlays
        uiView.setRegion(region, animated: false)
        uiView.addOverlay(overlay)
        
        if self.isNavigating {
            uiView.removeOverlays(uiView.overlays)
            addAnnotations(to: uiView)
            navigateToLocation(using: self.mapView)
        }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        var locationManager = CLLocationManager()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.locationManager.delegate = self
            self.requestLocationAuthorization()
        }
        
        func requestLocationAuthorization() {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            switch authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                // locationManager.requestAlwaysAuthorization()
            case .restricted, .denied: break
            case .authorizedWhenInUse, .authorizedAlways:
                    locationManager.startUpdatingLocation()
            @unknown default:
                fatalError("Unhandled authorization status: \(authorizationStatus)")
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
            if let currentLocation = locations.first?.coordinate {
                DispatchQueue.main.async {
                    self.parent.myPlace = currentLocation
                }
                print(currentLocation)
            }
        }
        
        @objc func navigate(_ sender: UIButton) {
            parent.isNavigating = true
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemMint
                renderer.lineWidth = 4.0
                return renderer
            } else if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.systemMint.withAlphaComponent(0.5)
                renderer.strokeColor = UIColor.systemMint
                renderer.lineWidth = 2
                return renderer
            }
            
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MyPinAnnotation {
                let identifier = "MyPinAnnotation"
                var view: MKAnnotationView
                if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
                } else {
                    view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    view.canShowCallout = true
                    view.calloutOffset = CGPoint(x: 0, y: 20)
                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                    view.image = UIImage(named: "pin")
                }
                return view
            }
            return nil
        }
    }
    
    func navigateToLocation(using mapView: MKMapView) {
        let fromPlacemark = MKPlacemark(coordinate: myPlace ?? defaultCoordinate)
        let toPlacemark = MKPlacemark(coordinate: finishPlace )
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
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
//                    let rect = route.polyline.boundingMapRect
//                    self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40), animated: true)
//                    
//                    let region = MKCoordinateRegion(route.polyline.boundingMapRect)
//                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
        
    }
    
    class MyPinAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
      
        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
    }
    
}


extension MapView {
    func addAnnotations(to mapView: MKMapView) {
        let destinationAnnotation = MyPinAnnotation(coordinate: finishPlace, title: "Destination", subtitle: "Mental Health Center")
        mapView.addAnnotation(destinationAnnotation)
    }
}




