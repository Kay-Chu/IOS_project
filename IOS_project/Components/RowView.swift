//
//  RowView.swift
//  IOS_project
//
//  Created by KA YING CHU on 25/1/2024.
//

import SwiftUI

struct RowView: View {
    
    let imageName: String
    let title: String
    let tintColor: Color
    
    
    var body: some View {
        HStack(spacing:12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.black)
        }
    }
}

//#Preview {
//    RowView()
//}
