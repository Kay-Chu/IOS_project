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
    
    
    var body: some View {
        
        if viewModel.currentUser != nil {
            VStack {
                Text("School")
                MapView(isNavigating: $isNavigating,
                                       myPlace: $myPlace,
                                       navType: 0)

            }.padding()
            
        }
        
        
    }
}

struct SchoolInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolInfoView()
            .environmentObject(AuthViewModel())
    }
}
