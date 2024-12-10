import SwiftUI

struct IdeasView: View {
    @State private var ideas: [Idea] = []
    @State private var showingAddIdea = false
    
    // 示例颜色数组
    let colors = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4",
        "#FFEEAD", "#D4A5A5", "#9B59B6", "#3498DB",
        "#E74C3C", "#2ECC71", "#F1C40F", "#1ABC9C"
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ideas) { idea in
                        IdeaCard(idea: idea)
                    }
                }
                .padding()
            }
            .navigationTitle("想法仓库")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddIdea = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddIdea) {
                AddIdeaView(ideas: $ideas)
            }
        }
        .onAppear {
            loadIdeas()
        }
    }
    
    private func loadIdeas() {
        // TODO: 从 DataManager 加载想法
        // 临时示例数据
        ideas = [
            Idea(title: "新项目想法", content: "开发一个帮助人们记录和分享想法的应用", color: colors[0], createdAt: Date()),
            Idea(title: "读书笔记", content: "关于效率提升的一些思考", color: colors[1], createdAt: Date()),
            Idea(title: "周末计划", content: "整理一下最近的想法和计划", color: colors[2], createdAt: Date())
        ]
    }
}

struct IdeaCard: View {
    let idea: Idea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(idea.title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(idea.content)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(3)
            
            Spacer()
            
            Text(formatDate(idea.createdAt))
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .frame(height: 160)
        .background(Color(hex: idea.color))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct AddIdeaView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var ideas: [Idea]
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedColor = "#FF6B6B"
    
    let colors = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4",
        "#FFEEAD", "#D4A5A5", "#9B59B6", "#3498DB"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("标题")) {
                    TextField("输入标题", text: $title)
                }
                
                Section(header: Text("内容")) {
                    TextEditor(text: $content)
                        .frame(height: 100)
                }
                
                Section(header: Text("颜色")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 8) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(hex: color))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(color == selectedColor ? Color.white : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
            }
            .navigationTitle("新想法")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    saveIdea()
                }
                .disabled(title.isEmpty || content.isEmpty)
            )
        }
    }
    
    private func saveIdea() {
        let newIdea = Idea(
            title: title,
            content: content,
            color: selectedColor,
            createdAt: Date()
        )
        ideas.append(newIdea)
        // TODO: 保存到 DataManager
        presentationMode.wrappedValue.dismiss()
    }
}

// 用于解析十六进制颜色的扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
