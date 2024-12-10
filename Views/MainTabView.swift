import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
                .tag(0)
            
            TaskCustomView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("任务定制")
                }
                .tag(1)
            
            DataCenterView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("数据中心")
                }
                .tag(2)
            
            IdeasView()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("想法仓库")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(4)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}