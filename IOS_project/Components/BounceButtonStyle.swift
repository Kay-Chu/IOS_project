//
//  BounceButtonStyle.swift
//  IOS_project
//
//  Created by KA YING CHU on 28/1/2024.
//

import SwiftUI

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10)
                .foregroundColor(.white)
                .background(Color.mint)
                .cornerRadius(5)
                .shadow(radius: 2)
                
        }
}

