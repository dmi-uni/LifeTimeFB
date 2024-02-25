import Foundation
import SwiftUI

struct Activity: Codable, Identifiable {
    let id: String
    let title: String
    var dateAdded: String
    var totalTime: TimeInterval
    var goal: TimeInterval
    var goalType: String
    var goalCompleted: Int
    var color: String
}