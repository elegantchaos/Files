// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 06/03/20.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

#if os(iOS) || os(macOS) || os(tvOS)

public extension URL.BookmarkCreationOptions {
    static var defaultSecureBookmarkOptions: URL.BookmarkCreationOptions {
        #if os(macOS) || targetEnvironment(macCatalyst)
            return .withSecurityScope
        #else
            return Self()
        #endif
    }
}

public extension URL {
    
    /// Do something with a security scoped resource.
    func accessSecurityScopedResource(withPathComponents components: [String] = [], block: (URL) -> Void) {
        guard startAccessingSecurityScopedResource() else {
            return
        }
        
        defer { stopAccessingSecurityScopedResource() }
        
        let targetURL = appendingPathComponents(components)
        block(targetURL)
    }
    
    /// Returns bookmark data for a security scoped URL.
    /// - Parameter options: bookmark creation options
    /// - Returns: The bookmark data, or nil if something goes wrong.
    func secureBookmark(options:  URL.BookmarkCreationOptions = .defaultSecureBookmarkOptions) -> Data? {
        guard startAccessingSecurityScopedResource() else {
            return nil
        }
        
        defer { stopAccessingSecurityScopedResource() }
        
        return try? bookmarkData(options: options, includingResourceValuesForKeys: nil, relativeTo: nil)
    }
    
    /// Take some data returned from `secureBookmark`, and turn it back into a URL
    /// - Parameter data: The bookmark data.
    /// - Returns: The URL, or nil if something goes wrong or the data was stale.
    static func resolveSecureBookmark(_ data: Data) -> URL? {
        var isStale = false
        guard let resolved = try? URL(resolvingBookmarkData: data, bookmarkDataIsStale: &isStale), !isStale else {
            return nil
        }
        
        return resolved
    }
}

#endif
