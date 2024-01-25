 //
//  InputView.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    let imageName: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment:.bottom, spacing:12) {
                InputIconView(imageName: imageName)
                    .frame(width:25)
                InputFieldView(text: $text, placeholder: placeholder, isSecureField: isSecureField)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.bottom, 12)
        }
    }
}

#Preview {
    InputView(text: .constant("name"), imageName: "person", placeholder: "name")
}


