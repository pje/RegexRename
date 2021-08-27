import Foundation

extension String {
  enum StringOrRegex {
    case string(String)
    case regex(NSRegularExpression)
  }

  func matches(_ pattern: String, as _: StringOrRegex = StringOrRegex.string("")) -> [NSTextCheckingResult] {
    let maybeRegex = try? NSRegularExpression(pattern: pattern)
    return (maybeRegex?.matches(in: self, range: NSRange(location: 0, length: count)) ?? [])
  }

  // Returns a new string
  func replace(_ regex: NSRegularExpression, _ replace: String = "") -> String {
    String.replace(self, regex, replace)
  }

  // Returns a new string
  static func replace(_ input: String, _ regex: NSRegularExpression, _ replace: String = "") -> String {
    let range = regex.rangeOfFirstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count))
    if range.length > 0 {
      return regex.stringByReplacingMatches(
        in: input,
        options: [],
        range: range,
        withTemplate: replace
      )
    } else {
      return input
    }
  }
}
