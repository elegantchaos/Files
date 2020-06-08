// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol FolderItem {
    var ref: FolderManager.Ref { get }
    var path: String { get }
    var isFile: Bool { get }
    var isHidden: Bool { get }
}

public extension FolderItem {
    var isHidden: Bool {
        let values = try? ref.url.resourceValues(forKeys: [.isHiddenKey])
        return values?.isHidden ?? false
    }
    
    var path: String {
        ref.url.path
    }
}
