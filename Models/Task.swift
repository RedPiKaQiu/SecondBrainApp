import Foundation

struct Task: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
    var type: Int // 0: 日常任务, 1: 主线任务, 2: 支线任务
    var scheduledTime: Date
    
    var category: TaskCategory {
        TaskCategory(rawValue: type) ?? .daily
    }
    
    // 实现 Equatable 协议的相等性比较
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.isCompleted == rhs.isCompleted &&
               lhs.type == rhs.type &&
               lhs.scheduledTime == rhs.scheduledTime
    }
}

enum TaskCategory: Int {
    case daily = 0  // 日常任务
    case main = 1   // 主线任务
    case side = 2   // 支线任务
    
    var name: String {
        switch self {
        case .daily: return "日常"
        case .main: return "主线"
        case .side: return "支线"
        }
    }
}
