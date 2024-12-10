import SwiftUI

struct AddTaskSheet: View {
    @Binding var isPresented: Bool
    let taskType: Int
    
    @State private var title = ""
    @State private var description = ""
    @State private var scheduledTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("任务信息")) {
                    TextField("任务标题", text: $title)
                    TextField("任务描述", text: $description)
                }
                
                Section(header: Text("计划时间")) {
                    DatePicker("执行时间", selection: $scheduledTime, displayedComponents: [.hourAndMinute])
                }
            }
            .navigationTitle("添加新任务")
            .navigationBarItems(
                leading: Button("取消") {
                    isPresented = false
                },
                trailing: Button("添加") {
                    addTask()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func addTask() {
        let task = Task(
            title: title,
            description: description,
            isCompleted: false,
            type: taskType,
            scheduledTime: scheduledTime
        )
        NotificationCenter.default.post(name: .didAddNewTask, object: task)
        isPresented = false
    }
}
