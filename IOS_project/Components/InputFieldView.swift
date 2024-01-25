//
//  InputFieldView.swift
//  IOS_project
//
//  Created by KA YING CHU on 25/1/2024.
//

import SwiftUI

struct InputFieldView: View {
    
    
    @Binding var text: String
    let placeholder: String
    var isSecureField = false
    
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment:.bottom, spacing:12) {
                if isSecureField {
                    SecureField(placeholder, text: $text)
                        .font(.system(size:14))
                        .textInputAutocapitalization(.none)
                        .padding()
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size:14))
                        .textInputAutocapitalization(.none)
                        .padding()
                }
            }
        }
        .frame(width: 250)
        
    }
}


