// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public extension FileManager {
    func cacheDirectory() -> URL {
        guard let url = urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("unable to get system cache directory - serious problems")
        }
        
        return url
    }

    func temporaryDirectory() -> URL {
        guard let url = urls(for: .itemReplacementDirectory, in: .userDomainMask).first else {
            fatalError("unable to get system cache directory - serious problems")
        }
        
        return url
    }

    func documentsDirectory() -> URL {
        guard let documentsURL = urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("unable to get system docs directory - serious problems")
        }
        
        return documentsURL
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
