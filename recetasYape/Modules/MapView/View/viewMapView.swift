//
//  viewMapView.swift
//  recetasYape
//
//  Created by Sergio Luis Noriega Pita on 19/05/24.
//

import SwiftUI
import MapKit

struct viewMapView: View {
    var latitude: Double
    var longitude: Double
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [LocationCoordinate(latitude: latitude, longitude: longitude)]) { location in
            MapPin(coordinate: location.coordinate)
        }
        .onAppear {
            region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        .navigationTitle("Mapa de Origen")
    }
}

struct LocationCoordinate: Identifiable {
    let id = UUID()
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
