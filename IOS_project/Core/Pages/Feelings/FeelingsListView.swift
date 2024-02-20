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
        db.collection("users").document(userId).collection("feelings")
        .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else if let querySnapshot = querySnapshot {
//                        print("got feeling:\(querySnapshot.documents)")
                        self.feelings = querySnapshot.documents.compactMap { document -> Feeling? in
                            do {
                                return try document.data(as: Feeling.self)
                            } catch {
                                print("Error decoding document \(document.documentID): \(error)")
                                return nil
                            }
                        }
                    }
                }
            }
    }

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(feelings) { feeling in
                        NavigationLink(destination: FeelingDetailView(feeling: feeling)) {
                            VStack(alignment: .leading) {
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
                    .onDelete(perform: deleteFeeling)
                }
                .navigationTitle("Feelings")
                    .font(.custom("Cabal", size: 20))
                .onAppear {
                    loadFeelings()
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
        guard let userId = viewModel.currentUser?.uid else {
            print("User ID is nil")
            return
        }
        let db = Firestore.firestore()

        for index in offsets {
            let feelingId = feelings[index].id
            db.collection("users").document(userId).collection("feelings").document(feelingId).delete { error in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.feelings.remove(at: index)
                        print("Document successfully removed!")
                    }
                }
            }
        }
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
        ZStack {
            Color.mint.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(feeling.title)
                    .font(.custom("Cabal-Bold", size: 30))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(feeling.content)
                    .font(.custom("Cabal", size: 15))
                    .padding([.leading, .trailing, .bottom])
                
                Spacer()
            }
        }
    }
}

struct FeelingsListView_Previews: PreviewProvider {
    static var previews: some View {
        FeelingsListView()
    }
}
