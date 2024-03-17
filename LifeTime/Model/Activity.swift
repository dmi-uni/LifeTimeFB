import Foundation
import SwiftUI

struct Activity: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    var dateAdded: String
    var totalTime: TimeInterval
    var goal: TimeInterval
    var goalType: String
    var goalCompletedCount: Int
    var color: String
    var notificationsEnabled: Bool
    var notificationTime: String?
    var notificationDays: [Day]?
    
    static let `default` = Activity(id: UUID().uuidString, title: "Чтение", dateAdded: "2024-05-14T18:36:00+05:00", totalTime: 0, goal: 0, goalType: GoalType.weekly.rawValue, goalCompletedCount: 0, color: "#21B44A", notificationsEnabled: false)
}
