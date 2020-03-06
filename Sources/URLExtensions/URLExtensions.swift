import Foundation

public extension URL {
    func appendingPathComponents(_ components: [String]) -> URL {
        var url = self
        for component in components {
            url.appendPathComponent(component)
        }
        return url
    }

    func accessSecurityScopedResource(withPathComponents components: [String], block: (URL) -> Void) {
        guard startAccessingSecurityScopedResource() else {
            return
        }

        defer { stopAccessingSecurityScopedResource() }

        let targetURL = appendingPathComponents(components)
        block(targetURL)
    }

    //    func accessSecurityScopedResource(withPathComponents components: [String], block: (URL) -> Void) {
    //        var stopList: [URL] = []
    //        var remaining = components
    //        var url = self
    //        while !remaining.isEmpty, let component = remaining.first {
    //            if !url.startAccessingSecurityScopedResource() {
    //                break
    //            }
    //
    //            stopList.insert(url, at: 0)
    //            url = url.appendingPathComponent(component)
    //            remaining.removeFirst()
    //        }
    //
    //        if remaining.isEmpty {
    //            block(url)
    //        }
    //
    //        for url in stopList {
    //            url.stopAccessingSecurityScopedResource()
    //        }
    //    }

}
