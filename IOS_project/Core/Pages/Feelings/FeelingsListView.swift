import SwiftUI
import Firebase
import FirebaseFirestore


struct FeelingsListView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var feelings: [Feeling] = []
    @State private var isAddingFeeling = false
    
    private func loadFeelings() {
        guard let userId = viewModel.currentUser?.uid else {
            print("User ID is nil")
            return
        }
        let db = Firestore.firestore()
        let userFeelingsRef = db.collection("users").document(userId).collection("feelings")
        
        userFeelingsRef
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else if let querySnapshot = querySnapshot {
                        print("got feeling:\(querySnapshot.documents)")
                        self.feelings = querySnapshot.documents.compactMap { document -> Feeling? in
                            do {
                                return try document.data(as: Feeling.self)
                            } catch {
                                print("Error decoding document \(document.documentID): \(error)")
                                return nil
                            }
                        }
                        print("loaded feeling:\(self.feelings)")
                    }
                }
            }
    }

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(feelings) { feeling in
//                        Text("testing 2")
                        NavigationLink(destination: FeelingDetailView(feeling: feeling)) {
//                            Text("testing 3")
                            VStack(alignment: .leading) {
//                                Text("testing 4")
                                Text(feeling.title)
                                    .fontWeight(.bold)
                                Text(feeling.content)
                                    .lineLimit(1)
                                Text(feeling.timestamp, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
//                    .onDelete(perform: deleteFeeling)
                }
                .navigationTitle("Feelings")
                .onAppear {
                    loadFeelings()
                    print(feelings)
                }

                addButton
            }
            .sheet(isPresented: $isAddingFeeling) {
                NewFeelingView(isPresented: $isAddingFeeling, feelings: $feelings)
                                    .environmentObject(viewModel)
            }
        }
    }

    private func deleteFeeling(at offsets: IndexSet) {
        //
    }

    private var addButton: some View {
        Button(action: {
            isAddingFeeling = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.mint)
        }
        .padding(26)
    }
}

struct FeelingDetailView: View {
    let feeling: Feeling

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(feeling.title)
                .font(.title)
                .fontWeight(.bold)
            Text(feeling.content)
                .font(.body)
        }
        .padding()
        .navigationTitle(feeling.title)
    }
}

struct FeelingsListView_Previews: PreviewProvider {
    static var previews: some View {
        FeelingsListView()
    }
}
