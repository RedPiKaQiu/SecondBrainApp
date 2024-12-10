import Foundation

struct UserStatus: Equatable {
    var energyLevel: Int // 0-100
    var medicationTaken: Bool
    var menstrualStatus: Bool
    var mood: MoodType
    
    enum MoodType: String, CaseIterable {
        case happy = "开心"
        case normal = "平静"
        case sad = "低落"
        case angry = "生气"
        case tired = "疲惫"
        
        var icon: String {
            switch self {
            case .happy: return "face.smiling"
            case .normal: return "face.neutral"
            case .sad: return "face.frown"
            case .angry: return "face.angry"
            case .tired: return "face.exhaling"
            }
        }
    }
}
