import Foundation

class Utils {
    static func removeTimeFromDate(of date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    static func calculateDaysUntilNow(from start: Date) -> String {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: start)
        let endOfDate = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: startOfDate, to: endOfDate)
        return String(components.day ?? 0)
    }
    
    static func formatDateToText(
        of date: Date,
        format: String = "EEEE, MMM d, yyyy",
        locale: String = "es_MX") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: date)
    }
}
