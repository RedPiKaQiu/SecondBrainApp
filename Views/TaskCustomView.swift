import SwiftUI

struct TaskCustomView: View {
    @State private var selectedTaskType = 0
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 任务类型选择器
                Picker("任务类型", selection: $selectedTaskType) {
                    Text("日常任务").tag(0)
                    Text("主线任务").tag(1)
                    Text("支线任务").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 任务列表
                TaskListView(taskType: selectedTaskType)
                    .padding(.top)
            }
            .navigationTitle("任务管理")
            .navigationBarItems(trailing: Button(action: {
                showingAddTask = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddTask) {
                AddTaskSheet(isPresented: $showingAddTask, taskType: selectedTaskType)
            }
        }
    }
}

extension Notification.Name {
    static let didAddNewTask = Notification.Name("didAddNewTask")
}
