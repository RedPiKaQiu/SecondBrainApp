import SwiftUI

struct HomeView: View {
    @State private var userStatus = UserStatus(
        energyLevel: 80,
        medicationTaken: false,
        menstrualStatus: false,
        mood: .normal
    )
    
    @State private var tasks: [Task] = []
    @State private var chatMessage: String = ""
    @State private var chatMessages: [(isUser: Bool, message: String)] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // 状态栏
                StatusBarView(userStatus: $userStatus)
                    .padding(.horizontal)
                
                Divider()
                
                // 当前任务卡片
                CurrentTaskCard(tasks: $tasks)
                    .padding(.horizontal)
                
                Divider()
                
                // 今日时间轴
                TimelineView(tasks: $tasks)
                    .padding(.horizontal)
                
                Divider()
                
                // AI聊天窗口
                ChatView(message: $chatMessage, messages: $chatMessages)
                    .frame(height: 200)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            // 加载保存的数据
            if let savedUserStatus = DataManager.shared.loadUserStatus() {
                userStatus = savedUserStatus
            }
            tasks = DataManager.shared.loadTasks()
        }
        .onChange(of: userStatus) { newValue in
            // 保存用户状态变化
            DataManager.shared.saveUserStatus(newValue)
        }
        .onChange(of: tasks) { newValue in
            // 保存任务变化
            DataManager.shared.saveTasks(newValue)
        }
    }
    
    private func loadSampleData() {
        // 只有在没有保存的任务时才加载示例数据
        if tasks.isEmpty {
            tasks = [
                Task(title: "服用早餐药物", description: "按时服用早餐药物", isCompleted: false, type: 0, scheduledTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!),
                Task(title: "完成工作报告", description: "完成并提交工作报告", isCompleted: false, type: 1, scheduledTime: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!),
                Task(title: "午休", description: "午休时间", isCompleted: false, type: 0, scheduledTime: Calendar.current.date(bySettingHour: 12, minute: 30, second: 0, of: Date())!)
            ]
        }
    }
}

// 状态栏视图
struct StatusBarView: View {
    @Binding var userStatus: UserStatus
    
    var body: some View {
        HStack(spacing: 20) {
            // 能量值
            VStack {
                Image(systemName: "battery.100")
                Text("\(userStatus.energyLevel)%")
                    .font(.caption)
            }
            
            // 服药状态
            VStack {
                Image(systemName: userStatus.medicationTaken ? "pills.fill" : "pills")
                    .foregroundColor(userStatus.medicationTaken ? .green : .gray)
                Text(userStatus.medicationTaken ? "已服药" : "未服药")
                    .font(.caption)
            }
            .onTapGesture {
                userStatus.medicationTaken.toggle()
            }
            
            // 生理期
            VStack {
                Image(systemName: userStatus.menstrualStatus ? "heart.fill" : "heart")
                    .foregroundColor(userStatus.menstrualStatus ? .red : .gray)
                Text(userStatus.menstrualStatus ? "生理期" : "非生理期")
                    .font(.caption)
            }
            
            // 心情
            VStack {
                Image(systemName: userStatus.mood.icon)
                Text(userStatus.mood.rawValue)
                    .font(.caption)
            }
            .onTapGesture {
                let allMoods = UserStatus.MoodType.allCases
                if let currentIndex = allMoods.firstIndex(of: userStatus.mood),
                   let nextMood = allMoods[safe: (currentIndex + 1) % allMoods.count] {
                    userStatus.mood = nextMood
                }
            }
        }
    }
}

// 当前任务卡片
struct CurrentTaskCard: View {
    @Binding var tasks: [Task]
    
    var uncompletedTasks: [Task] {
        tasks.filter { !$0.isCompleted }.prefix(3).map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("当前任务")
                .font(.headline)
            
            ForEach(uncompletedTasks) { task in
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                        .onTapGesture {
                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                tasks[index].isCompleted.toggle()
                            }
                        }
                    
                    Text(task.title)
                    
                    Spacer()
                    
                    Text(task.category.name)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

// 时间轴视图
struct TimelineView: View {
    @Binding var tasks: [Task]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("今日时间轴")
                .font(.headline)
            
            ForEach(sortedTasks) { task in
                HStack {
                    VStack {
                        Text(formatDate(task.scheduledTime))
                            .font(.caption)
                            .foregroundColor(.gray)
                        Circle()
                            .fill(task.isCompleted ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                    .frame(width: 50)
                    
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                        .onTapGesture {
                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                tasks[index].isCompleted.toggle()
                            }
                        }
                    
                    VStack(alignment: .leading) {
                        Text(task.title)
                        Text(task.category.name)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private var sortedTasks: [Task] {
        tasks.sorted { $0.scheduledTime < $1.scheduledTime }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// AI聊天窗口
struct ChatView: View {
    @Binding var message: String
    @Binding var messages: [(isUser: Bool, message: String)]
    
    var body: some View {
        VStack {
            Text("AI助手")
                .font(.headline)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(messages.indices, id: \.self) { index in
                        ChatBubble(message: messages[index])
                    }
                }
            }
            
            HStack {
                TextField("输入消息...", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
    
    private func sendMessage() {
        guard !message.isEmpty else { return }
        messages.append((isUser: true, message: message))
        // 这里可以添加AI响应逻辑
        message = ""
    }
}

struct ChatBubble: View {
    let message: (isUser: Bool, message: String)
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.message)
                .padding(10)
                .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(10)
            
            if !message.isUser { Spacer() }
        }
    }
}

// Array安全访问扩展
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
