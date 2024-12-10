import SwiftUI

struct TaskDetailView: View {
    let task: Task
    
    var body: some View {
        Form {
            Section(header: Text("任务信息")) {
                HStack {
                    Text("标题")
                    Spacer()
                    Text(task.title)
                }
                
                HStack {
                    Text("描述")
                    Spacer()
                    Text(task.description)
                }
                
                HStack {
                    Text("状态")
                    Spacer()
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
                
                HStack {
                    Text("计划时间")
                    Spacer()
                    Text(formatDate(task.scheduledTime))
                }
                
                HStack {
                    Text("类型")
                    Spacer()
                    Text(taskTypeString(task.type))
                }
            }
        }
        .navigationTitle("任务详情")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    private func taskTypeString(_ type: Int) -> String {
        switch type {
        case 0: return "日常任务"
        case 1: return "主线任务"
        case 2: return "支线任务"
        default: return "未知类型"
        }
    }
}

struct CustomTaskDetailView: View {
    @State var task: CustomTask
    @State private var newPrepStep: String = ""
    @State private var newExecStep: String = ""
    
    var body: some View {
        List {
            // 准备阶段
            Section(header: Text("准备阶段")) {
                // 添加新准备步骤
                HStack {
                    TextField("添加准备步骤", text: $newPrepStep)
                    Button(action: addPrepStep) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                // 显示现有准备步骤
                ForEach(task.preparationSteps, id: \.self) { step in
                    Text(step)
                }
                .onDelete(perform: deletePrepStep)
            }
            
            // 执行阶段
            Section(header: Text("执行阶段")) {
                // 添加新执行步骤
                HStack {
                    TextField("添加执行步骤", text: $newExecStep)
                    Button(action: addExecStep) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                // 显示现有执行步骤
                ForEach(task.executionSteps, id: \.self) { step in
                    Text(step)
                }
                .onDelete(perform: deleteExecStep)
            }
            
            // 完成状态
            Toggle("标记为已完成", isOn: $task.isCompleted)
        }
        .navigationTitle(task.title)
    }
    
    private func addPrepStep() {
        guard !newPrepStep.isEmpty else { return }
        task.preparationSteps.append(newPrepStep)
        newPrepStep = ""
    }
    
    private func addExecStep() {
        guard !newExecStep.isEmpty else { return }
        task.executionSteps.append(newExecStep)
        newExecStep = ""
    }
    
    private func deletePrepStep(at offsets: IndexSet) {
        task.preparationSteps.remove(atOffsets: offsets)
    }
    
    private func deleteExecStep(at offsets: IndexSet) {
        task.executionSteps.remove(atOffsets: offsets)
    }
}
