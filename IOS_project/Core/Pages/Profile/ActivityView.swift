//
//  ActivityView.swift
//  IOS_project
//
//  Created by KA YING CHU on 28/1/2024.
//

import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

//#Preview {
//    ActivityView(activityItems: <#T##[Any]#>)
//}
