

import UIKit

class Utility {
    
    // Returns true is value is a whole number, false if not
    public static func formatNumber(_ value : Double) -> Bool {
        return value - floor(value) == 0
    }
    
    // Formats value to reduce extraneous trailing numbers
    public static func formatDecimal(_ value : Double) -> Double {
        return Double(round(10000000000 * value)/10000000000)
    }
    
    // Removes the trailing zero from whole numbers
    // E.g. 2.0 -> 2
    public static func removeTrailingZero(_ string : String) -> String? {
        if Utility.formatNumber(Double(string) ?? 0) {
            return String(Int(Double(string) ?? 0))
        } else {
            return string
        }
    }
    
    // Returns true if device's orientation is portrait
    public static func isPortrait() -> Bool {
        return UIScreen.main.bounds.width < UIScreen.main.bounds.height
    }
    
    public static func formatResultLabel(_ resultLabel : String) -> String {
        guard !(Double(resultLabel)?.isInfinite ?? false) else { return "Not a number" }
        
        guard let resultToDouble = Double(resultLabel),
                  resultLabel.count > 13 else { return resultLabel }
        
        return resultToDouble.scientificFormatted
    }
}

// Returns true if character is a number
extension String {
    public var isNumeric : Bool {
        return Double(self) != nil
    }
}

// Removes trailing zeros from double
extension Double {
    var clean : String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

// Formats number to be scientific
extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
}

extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}

