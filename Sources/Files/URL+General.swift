import Foundation

public extension URL {
    func appendingPathComponents(_ components: [String]) -> URL {
        var url = self
        for component in components {
            url.appendPathComponent(component)
        }
        return url
    }
}
