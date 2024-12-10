import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                // 用户基本信息
                Section(header: Text("个人信息")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                        VStack(alignment: .leading) {
                            Text("用户名")
                                .font(.headline)
                            Text("用户ID: 12345")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("年龄")
                        Spacer()
                        Text("25岁")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("性别")
                        Spacer()
                        Text("女")
                            .foregroundColor(.gray)
                    }
                }
                
                // 用户状态
                Section(header: Text("当前状态")) {
                    Toggle("ADHD确诊", isOn: .constant(true))
                    Toggle("经期状态", isOn: .constant(false))
                    HStack {
                        Text("当前情绪")
                        Spacer()
                        Text("😊 愉快")
                            .foregroundColor(.gray)
                    }
                }
                
                // 用户偏好设置
                Section(header: Text("偏好设置")) {
                    NavigationLink("勿扰时间设置") {
                        Text("勿扰时间设置页面")
                    }
                    Toggle("任务提醒", isOn: .constant(true))
                }
            }
            .navigationTitle("个人中心")
        }
    }
} 
