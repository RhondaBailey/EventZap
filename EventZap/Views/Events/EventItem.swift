//
//  EventItem.swift
//  EventZapp
//
//  Created by Rhonda Bailey on 7/17/23.
//

import SwiftUI
import MapKit

struct EventItem: View {
    var event: Event
    @State private var annotation = MKPointAnnotation()

    var body: some View {
        VStack(spacing: 0) {
            /*Image(event.imageName ?? "default_image_name")
                .resizable()
                .aspectRatio(3 / 2, contentMode: .fit)
                .opacity(0.6)
                .overlay {
                    TextOverlay(event: event)
                }*/
                if let imageData = event.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.6)
                        .overlay {
                            TextOverlay(event: event)
                        }
                } else {
                    Image("saddle1") // Use a default image if event.image is nil
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.6)
                        .overlay {
                            TextOverlay(event: event)
                        }
                }
                Divider()
            MapView(coordinate: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude), annotation: $annotation)
                .frame(height: 280)
                .onAppear {
                    // Set the annotation for the pin
                    annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                }
        }
        .padding([.horizontal], 5)
        .onAppear {
                    // Print the coordinates when the view appears
            
                }
    }
}

struct TextOverlay: View {
    var event: Event
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
        gradient
        VStack(alignment: .leading) {
            Text(event.name ?? "")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
            HStack {
                Text(event.startDate ?? "")
                    .foregroundStyle(.white)
                Text("-")
                Text(event.endDate ?? "")
                    .foregroundStyle(.white)
            }
            Text(event.facilityName  ?? "")
                .foregroundStyle(.white)
        }
        .padding()
            
    }
    .foregroundColor(.white)
        
    }
}

struct EventItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // or use VStack, List, or any other suitable container
            EventItem(event: previewEvent)
        }
    }
    
    static var previewEvent: Event {
        let previewEvent = Event()
        previewEvent.name = "Foo Too"
        previewEvent.startDate = "2023/12/30"
        previewEvent.endDate = "2023/12/31"
        previewEvent.facilityName = "Foo"
        previewEvent.imageName = "FHC_feature"
        return previewEvent
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    @Binding var annotation: MKPointAnnotation

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        uiView.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}



