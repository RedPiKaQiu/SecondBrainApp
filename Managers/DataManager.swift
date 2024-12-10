import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userStatusFileName = "user_status.txt"
    private let tasksFileName = "tasks.txt"
    private let appDirectory: URL = URL(fileURLWithPath: "/Users/pika/CODE/SecondBrainApp/DataBase")
    
    init() {
        // 确保目录存在
        do {
            try FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        } catch {
            print("Error creating app directory: \(error)")
        }
    }
        // private var appDirectory: URL {
    //     guard let bundleID = Bundle.main.bundleIdentifier else {
    //         // 如果无法获取 Bundle ID，则使用文档目录作为后备选项
    //         return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //     }
        
    //     let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    //     let appDir = appSupportDir.appendingPathComponent(bundleID)
        
    //     // 确保目录存在
    //     do {
    //         try FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
    //     } catch {
    //         print("Error creating app directory: \(error)")
    //     }
        
    //     return appDir
    // }
    // MARK: - User Status
    func saveUserStatus(_ userStatus: UserStatus) {
        let userStatusURL = appDirectory.appendingPathComponent(userStatusFileName)
        let data = """
        energyLevel:\(userStatus.energyLevel)
        medicationTaken:\(userStatus.medicationTaken)
        menstrualStatus:\(userStatus.menstrualStatus)
        mood:\(userStatus.mood.rawValue)
        """
        
        do {
            try data.write(to: userStatusURL, atomically: true, encoding: .ascii)
        } catch {
            print("Error saving user status: \(error)")
        }
    }
    
    func loadUserStatus() -> UserStatus? {
        let userStatusURL = appDirectory.appendingPathComponent(userStatusFileName)
        
        do {
            let content = try String(contentsOf: userStatusURL, encoding: .ascii)
            var energyLevel: Int = 80
            var medicationTaken: Bool = false
            var menstrualStatus: Bool = false
            var mood: UserStatus.MoodType = .normal
            
            let lines = content.components(separatedBy: .newlines)
            for line in lines {
                let parts = line.split(separator: ":")
                if parts.count == 2 {
                    let key = String(parts[0])
                    let value = String(parts[1])
                    
                    switch key {
                    case "energyLevel":
                        energyLevel = Int(value) ?? 80
                    case "medicationTaken":
                        medicationTaken = value == "true"
                    case "menstrualStatus":
                        menstrualStatus = value == "true"
                    case "mood":
                        mood = UserStatus.MoodType(rawValue: value) ?? .normal
                    default:
                        break
                    }
                }
            }
            
            return UserStatus(
                energyLevel: energyLevel,
                medicationTaken: medicationTaken,
                menstrualStatus: menstrualStatus,
                mood: mood
            )
        } catch {
            print("Error loading user status: \(error)")
            return nil
        }
    }
    
    // MARK: - Tasks
    func saveTasks(_ tasks: [Task]) {
        let tasksURL = appDirectory.appendingPathComponent(tasksFileName)
        var data = ""
        
        for task in tasks {
            let taskData = """
            ---START_TASK---
            title:\(task.title)
            description:\(task.description)
            isCompleted:\(task.isCompleted)
            type:\(task.type)
            scheduledTime:\(task.scheduledTime.timeIntervalSince1970)
            ---END_TASK---
            
            """
            data += taskData
        }
        
        do {
            try data.write(to: tasksURL, atomically: true, encoding: .ascii)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }
    
    func loadTasks() -> [Task] {
        let tasksURL = appDirectory.appendingPathComponent(tasksFileName)
        
        do {
            let content = try String(contentsOf: tasksURL, encoding: .ascii)
            let taskBlocks = content.components(separatedBy: "---START_TASK---")
                .filter { !$0.isEmpty }
            
            var tasks: [Task] = []
            
            for block in taskBlocks {
                var title = ""
                var description = ""
                var isCompleted = false
                var type = 0
                var scheduledTime = Date()
                
                let lines = block.components(separatedBy: .newlines)
                    .filter { !$0.isEmpty && !$0.contains("---END_TASK---") }
                
                for line in lines {
                    let parts = line.split(separator: ":")
                    if parts.count == 2 {
                        let key = String(parts[0])
                        let value = String(parts[1])
                        
                        switch key {
                        case "title":
                            title = value
                        case "description":
                            description = value
                        case "isCompleted":
                            isCompleted = value == "true"
                        case "type":
                            type = Int(value) ?? 0
                        case "scheduledTime":
                            if let timeInterval = Double(value) {
                                scheduledTime = Date(timeIntervalSince1970: timeInterval)
                            }
                        default:
                            break
                        }
                    }
                }
                
                let task = Task(
                    title: title,
                    description: description,
                    isCompleted: isCompleted,
                    type: type,
                    scheduledTime: scheduledTime
                )
                tasks.append(task)
            }
            
            return tasks
        } catch {
            print("Error loading tasks: \(error)")
            return []
        }
    }
}
