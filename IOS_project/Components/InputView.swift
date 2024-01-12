 //
//  InputView.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField { 
                SecureField(placeholder, text: $text)
                    .font(.system(size:14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size:14))
            }
            Divider()
        }
    }
}

//struct InputView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
//    }
//}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
