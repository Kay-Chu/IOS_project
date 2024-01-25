//
//  SchoolInfoView.swift
//  IOS_project
//
//  Created by KA YING CHU on 15/1/2024.
//

import SwiftUI
import MapKit
import SwiftUI

struct SchoolInfoView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel

    
    @State private var isNavigating: Bool = false
    @State private var myPlace: CLLocationCoordinate2D? = nil
    @State private var hasSetInitialScale = false
    
    @State private var showMap = false
    
    var body: some View {
        
//        if viewModel.currentUser != nil {
        GeometryReader { geometry in
            VStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mental Health Access Hubs")
                        .font(.title)
                        .padding(.horizontal, 20)
                    Text("Locality-based Mental Health Access Hubs (MHAH) are responsible for clinically triaging all patients and dealing with those in urgent need of care. There are three locality hubs for Coventry, North Warwickshire and Rugby, and South Warwickshire.")
                        .padding(.horizontal, 20)
                        .font(.subheadline)
                    Section {
                        Text("Client Age: ").bold() + Text("Adult")
                                    Text("Address: ").bold() + Text("Three locations: Caludon Centre Coventry; St Michael's Hospital, Warwick; Avenue House, Nuneaton.")
                                    Text("Reception phone number: ").bold() + Text("08081 966798")
                                    Text("Clinic hours: ").bold() + Text("24/7 365 days/year")
                            .font(.body)
                    }.background(Color.gray.opacity(0.1))
                        .padding(.horizontal, 20)
                }
                .frame(width: geometry.size.width)
                .padding(.top,20)
                .background(Color.white)
                
                if showMap {
                    MapView(isNavigating: $isNavigating, myPlace: $myPlace, hasSetInitialScale: $hasSetInitialScale, navType: 0)
                        .frame(height: 2 * geometry.size.height / 3)
                        .cornerRadius(25)
    //                    .padding()
                        .shadow(radius: 5)
                }
                
            }
            .frame(width: geometry.size.width)
            

        }
        .overlay(
                    Button(action: {
                        // Toggles the visibility of the map
                        showMap.toggle()
                    }) {
                        Image(systemName: showMap ? "map.fill" : "map") // Use SF Symbols for the button icon
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.mint)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(20), // Adjust the padding as needed
                    alignment: .bottomLeading
                )


            
            
//        }
        
        
    }
    
}

struct SchoolInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolInfoView()
            .environmentObject(AuthViewModel())
    }
}
