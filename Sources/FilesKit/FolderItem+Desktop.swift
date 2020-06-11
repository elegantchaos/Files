// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files

#if canImport(AppKit)

import Files
import AppKit

extension ThrowingItem {
    public func reveal() {
        NSWorkspace.shared.open(url)
    }
}

#else

extension FolderItem {
    public func reveal() {
        // TODO...
    }
}

#endif
