import Foundation

struct Idea: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var content: String
    var color: String // 存储颜色的十六进制字符串
    var createdAt: Date
    
    static func == (lhs: Idea, rhs: Idea) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.content == rhs.content &&
               lhs.color == rhs.color &&
               lhs.createdAt == rhs.createdAt
    }
}
