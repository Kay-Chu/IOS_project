import Foundation

struct Feeling: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var content: String
    var timestamp: Date = Date()

    init(userId: String, title: String, content: String) {
        self.title = title
        self.content = content
    }
}
