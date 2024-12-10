import SwiftUI

struct TaskListView: View {
    let taskType: Int
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    
    var filteredTasks: [Task] {
        tasks.filter { $0.type == taskType }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 任务列表
            List {
                ForEach(filteredTasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        TaskRow(task: task, onToggle: { toggleTask($0) })
                    }
                }
                .onDelete(perform: deleteTasks)
            }
        }
        .onAppear {
            loadTasks()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didAddNewTask)) { notification in
            if let newTask = notification.object as? Task {
                tasks.append(newTask)
                // 保存新添加的任务
                DataManager.shared.saveTasks(tasks)
            }
        }
    }
    
    private func loadTasks() {
        // 从 DataManager 加载任务
        tasks = DataManager.shared.loadTasks()
    }
    
    private func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            // 保存任务状态更改
            DataManager.shared.saveTasks(tasks)
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        let tasksToDelete = offsets.map { filteredTasks[$0] }
        tasks.removeAll { task in
            tasksToDelete.contains { $0.id == task.id }
        }
        // 保存删除后的任务列表
        DataManager.shared.saveTasks(tasks)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct TaskRow: View {
    let task: Task
    let onToggle: (Task) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    onToggle(task)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text(formatTime(task.scheduledTime))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
