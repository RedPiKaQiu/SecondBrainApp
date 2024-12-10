struct CustomTask: Identifiable {
    let id = 1000//UUID()
    var title: String
    var preparationSteps: [String]
    var executionSteps: [String]
    var isCompleted: Bool = false
} 