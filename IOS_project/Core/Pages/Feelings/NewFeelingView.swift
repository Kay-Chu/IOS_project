import SwiftUI

struct NewFeelingView: View {
    
    @Binding var isPresented: Bool
    @Binding var feelings: [Feeling]
    @State private var newFeelingTitle = ""
    @State private var newFeelingContent = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            TextField("Title", text: $newFeelingTitle)
                .padding()
            TextField("Content", text: $newFeelingContent)
                .padding()
            Button("Add") {
                // Assuming 'viewModel' is accessible here, if not, pass it in or use @EnvironmentObject
                let newFeeling = Feeling(userId: viewModel.currentUser!.uid, title: newFeelingTitle, content: newFeelingContent)
                Task {
                    do {
                        try await viewModel.saveFeelingToFirebase(feeling: newFeeling)
                    } catch {
                        print("Failed to save feeling to Firebase: \(error)")
                    }
                }
                newFeelingTitle = ""
                newFeelingContent = ""
                isPresented = false
            }
            .padding()
        }
    }
}
