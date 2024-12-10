import SwiftUI

struct DataCenterView: View {
    @State private var userStatus = UserStatus(
        energyLevel: 80,
        medicationTaken: false,
        menstrualStatus: false,
        mood: .normal
    )
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("健康数据")) {
                    HStack {
                        Text("能量水平")
                        Spacer()
                        Text("\(userStatus.energyLevel)%")
                    }
                    
                    HStack {
                        Text("服药状态")
                        Spacer()
                        Text(userStatus.medicationTaken ? "已服药" : "未服药")
                    }
                    
                    HStack {
                        Text("生理状态")
                        Spacer()
                        Text(userStatus.menstrualStatus ? "生理期" : "非生理期")
                    }
                    
                    HStack {
                        Text("心情")
                        Spacer()
                        Text(userStatus.mood.rawValue)
                    }
                }
                
                Section(header: Text("统计数据")) {
                    NavigationLink(destination: Text("任务完成率统计")) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                            Text("任务完成率")
                        }
                    }
                    
                    NavigationLink(destination: Text("心情趋势统计")) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("心情趋势")
                        }
                    }
                    
                    NavigationLink(destination: Text("能量水平统计")) {
                        HStack {
                            Image(systemName: "battery.100.bolt")
                            Text("能量水平")
                        }
                    }
                }
                
                Section(header: Text("数据导出")) {
                    Button(action: {
                        // TODO: 实现数据导出功能
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("导出数据")
                        }
                    }
                }
            }
            .navigationTitle("数据中心")
        }
    }
}
