//
//  InputIconView.swift
//  IOS_project
//
//  Created by KA YING CHU on 25/1/2024.
//

import SwiftUI

struct InputIconView: View {
    
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .imageScale(.large)
            .font(.title3)
            .foregroundColor(.gray)
    }
}

//#Preview {
//    InputIconView()
//}
