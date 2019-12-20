//
//  ContentView.swift
//  MapAppRoutes
//
//  Created by Erkan on 12/19/19.
//  Copyright © 2019 ErkanVolkan. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        mapView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct mapView : UIViewRepresentable {
    
    func makeCoordinator() -> mapView.Coordinator {
        return mapView.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<mapView>) -> MKMapView {
        
        let map = MKMapView()
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: 40.8120447, longitude: -74.1243096)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: 37.37, longitude: -122.04)
        let region = MKCoordinateRegion(center: sourceCoordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        let sourcePin = MKPointAnnotation()
        sourcePin.coordinate = sourceCoordinate
        sourcePin.title = "Source"
        map.addAnnotation(sourcePin)
        
        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destinationCoordinate
        destinationPin.title = "Destination"
        map.addAnnotation(destinationPin)
        
        map.region = region
        map.delegate = context.coordinator
        
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        
        let directions = MKDirections(request: req)
        directions.calculate { (direct,err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            let polyline = direct?.routes.first?.polyline
            map.addOverlay(polyline!)
            map.setRegion(MKCoordinateRegion(polyline!.boundingMapRect),animated: true)
        }
        
        
        
        return map
        
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<mapView>) {
    
    }
    class Coordinator : NSObject,MKMapViewDelegate{
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = .blue
            render.lineWidth = 4
            return render
        }
    }
    
}
