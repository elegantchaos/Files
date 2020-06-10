// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public extension FileManager {
    func systemDirectory(for directory: FileManager.SearchPathDirectory)-> URL {
        guard let url = urls(for: directory, in: .userDomainMask).first else {
            fatalError("unable to get \(directory) - serious problems")
        }
        
        return url
    }
    
    func cacheDirectory() -> URL { systemDirectory(for: .cachesDirectory) }
    func temporaryDirectory() -> URL {systemDirectory(for: .itemReplacementDirectory) }
    func desktopDirectory() -> URL { systemDirectory(for: .desktopDirectory) }
    func documentsDirectory() -> URL { systemDirectory(for: .documentDirectory) }

    func homeDirectory() -> URL {
        return URL(fileURLExpandingPath: "~/")
    }

    func workingDirectory() -> URL {
        return URL(fileURLWithPath: currentDirectoryPath)
    }


    /// Return a url to use as an initial location for a new file.
    /// - Parameters:
    ///   - nameRoot: The name to give the file. Defaults to "Untitled".
    ///   - pathExtension: The path extension to use for the new file.
    ///   - makeUnique: If true, we append numbers to the file name until we come up with one that doesn't already exist.
    /// - Returns: A new URL.
    ///
    /// If @makeUnique is false, and a file of the same name already exists there, it is first deleted.
    
    func newFileURL(in directory: URL, name nameRoot: String = "Untitled", withPathExtension pathExtension: String, makeUnique: Bool = true) -> URL {
        var name = nameRoot
        var count = 1
        repeat {
            let url = directory.appendingPathComponent(name).appendingPathExtension(pathExtension)
            if !makeUnique {
                try? removeItem(at: url)
            }
            if !fileExists(atURL: url) {
                return url
            }
            count += 1
            name = "\(nameRoot) \(count)"
        } while true
    }

    /// Return a url to use as an initial location for a new document.
    /// See `newFileURL` for parameters.

    func newDocumentURL(name: String = "Untitled", withPathExtension pathExtension: String, makeUnique: Bool = true) -> URL {
        let directory = cacheDirectory()
        return newFileURL(in: directory, name: name, withPathExtension: pathExtension, makeUnique: makeUnique)
    }

    /// Return a url to use as an initial location for a temporary file.
    /// See `newFileURL` for parameters.

    func newTemporaryURL(name: String = "Untitled", withPathExtension pathExtension: String, makeUnique: Bool = true) -> URL {
        let directory = temporaryDirectory()
        return newFileURL(in: directory, name: name, withPathExtension: pathExtension, makeUnique: makeUnique)
    }

}
