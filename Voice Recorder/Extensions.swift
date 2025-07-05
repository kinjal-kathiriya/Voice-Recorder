import Foundation

// ✅ Extension for Date.toString(...)
extension Date {
    func toString(dateFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// ✅ Extension for Data.append(String)
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
