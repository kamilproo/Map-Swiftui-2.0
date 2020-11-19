//
//  ContentView.swift
//  MapApp
//
//  Created by Камиль Зиязетдинов on 15.11.2020.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation.CLLocation
import MapKit.MKAnnotationView
import MapKit.MKUserLocation
struct ContentView: View {
    var body: some View {
        MapView()
    }
}


struct Home: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.086, longitude: 80.2769), latitudinalMeters: 50, longitudinalMeters: 50)
    @State var tracking: MapUserTrackingMode = .follow
    @State var manager = CLLocationManager()
    @StateObject var managerDelegate = locationDelegate()
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking).onAppear {
                manager.delegate = managerDelegate
            }
            
            VStack {
                if !(tracking == .follow) {
                               HStack {
                                   Spacer()
                                   Button(action: {
                                    withAnimation {
                                    followUser()
                                    }
                                   }) {
                                       Image(systemName: "location.fill")
                                        .frame(width: 25, height: 25)
                                        .modifier(MapButton(backgroundColor: .primary))
                                           
                                   }
                                   .padding(.trailing)
                               }
                               .padding(.top)
                           }
            }
        })
    }
    private func followUser() {
            tracking = .follow
        }
}

fileprivate struct MapButton: ViewModifier {
    
    let backgroundColor: Color
    var fontColor: Color = Color(UIColor.systemBackground)
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(self.backgroundColor.opacity(0.9))
            .foregroundColor(self.fontColor)
            .font(.title)
            .clipShape(Circle())
    }
    
}



class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?,
         subtitle: String?,
         coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func requestMockData()-> [LandmarkAnnotation]{
        return [
            LandmarkAnnotation(title: "Red Square",
                               subtitle:"Красная площадь",
                               coordinate: .init(latitude: 55.751999 , longitude: 37.617734))
        ]
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
      var mapViewController: MapView
        
      init(_ control: MapView) {
          self.mapViewController = control
      }
        
      func mapView(_ mapView: MKMapView, viewFor
           annotation: MKAnnotation) -> MKAnnotationView?{
          let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
          annotationView.canShowCallout = true
          annotationView.image = UIImage(named: "locationPin")
          return annotationView
       }
}

struct MapView: UIViewRepresentable {
  let landmarks = LandmarkAnnotation.requestMockData()
  func makeUIView(context: Context) -> MKMapView{
         MKMapView(frame: .zero)
    }
    func updateUIView(_ view: MKMapView, context: Context){
        view.addAnnotations(landmarks)
    }
}


class locationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedWhenInUse {
            print("")
            
            if manager.accuracyAuthorization != .fullAccuracy {
                print("")
            }
            
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Location") { (err) in
                if err != nil {
                    print(err!)
                    return
                }
            }
            
            manager.startUpdatingLocation()
        } else {
            print("")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
