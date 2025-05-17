public struct Version {
    public static let major = 1
    public static let minor = 0
    public static let patch = 0
    
    public static var current: String {
        return "\(major).\(minor).\(patch)"
    }
}