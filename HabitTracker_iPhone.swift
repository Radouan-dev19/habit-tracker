import SwiftUI

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var currentMonth = Date()
    @State private var selectedColor: HabitColor = .green
    @State private var markedDays: [String: HabitColor] = [:]

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                HStack {
                    Button {
                        changeMonth(-1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }

                    Spacer()

                    Text(monthTitle)
                        .font(.title2.bold())

                    Spacer()

                    Button {
                        changeMonth(1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    }
                }

                HStack {
                    colorButton(.green)
                    colorButton(.red)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(["L","M","M","J","V","S","D"], id: \.self) {
                        Text($0)
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                    }

                    ForEach(calendarDays.indices, id: \.self) { index in
                        if let day = calendarDays[index] {
                            let key = dayKey(day)

                            Button {
                                markedDays[key] = selectedColor
                            } label: {
                                Text("\(day)")
                                    .frame(maxWidth: .infinity, minHeight: 42)
                                    .background(markedDays[key]?.color ?? Color(.systemGray6))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            Color.clear.frame(height: 42)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Habitudes")
        }
    }

    func colorButton(_ color: HabitColor) -> some View {
        Button {
            selectedColor = color
        } label: {
            Text(color.rawValue.capitalized)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color.color)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedColor == color ? Color.black : .clear, lineWidth: 3)
                )
        }
    }

    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth).capitalized
    }

    var calendarDays: [Int?] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!

        let firstDay = calendar.date(from:
            calendar.dateComponents([.year, .month], from: currentMonth))!

        let weekday = calendar.component(.weekday, from: firstDay)
        let offset = weekday == 1 ? 6 : weekday - 2

        var result: [Int?] = Array(repeating: nil, count: offset)
        result.append(contentsOf: range.map { Optional($0) })
        return result
    }

    func dayKey(_ day: Int) -> String {
        let c = Calendar.current
        let y = c.component(.year, from: currentMonth)
        let m = c.component(.month, from: currentMonth)
        return "\(y)-\(m)-\(day)"
    }

    func changeMonth(_ value: Int) {
        currentMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
    }
}

enum HabitColor: String {
    case green
    case red

    var color: Color {
        switch self {
        case .green: return .green
        case .red: return .red
        }
    }
}
