import SwiftUI

struct AIChatView: View {
    @State private var messageText = ""
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            // 聊天记录显示区域
            ScrollView {
                // 聊天内容将在这里显示
            }
            .padding()
            
            // 输入区域
            HStack {
                Button(action: {
                    isRecording.toggle()
                }) {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(isRecording ? .red : .blue)
                }
                
                TextField("输入消息", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // 发送消息逻辑
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
} 