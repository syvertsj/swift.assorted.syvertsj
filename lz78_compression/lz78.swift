
import Foundation

func usage() { print("usage: \(CommandLine.arguments[0]) [-z|-x] [filename]") }

func compress(_ tokenList: [String]) -> String { 

    var wordOffset = [String : Int]()
    var compressedString = String()

    for (i, term) in tokenList.enumerated() {

        if wordOffset[term] != nil {
            compressedString.count == 0 ? compressedString.append("\(wordOffset[term]!)") : compressedString.append(" \(wordOffset[term]!)")
        } else {
            compressedString.count == 0 ? compressedString.append("\(term)"): compressedString.append(" \(term)")
            wordOffset[term] = i
        }
    }

    return compressedString
}

func uncompress(_ tokenList: [String]) -> String { 

    var wordOffset = [String : Int]()
    var uncompressedString = String()

    for (i, term) in tokenList.enumerated() {

        if Int(term) == nil {  // casting alpha to Int returns nil
            uncompressedString.count == 0 ? uncompressedString.append("\(term)") : uncompressedString.append(" \(term)")
            wordOffset[term] = i
        } else {
            let offset = Int(term)  // capture key matching value of token position 
            uncompressedString.append(" \(wordOffset.filter { key, value in value == offset }.first!.key)")
        }
    }

    return uncompressedString
}

// top level code
switch CommandLine.argc { case 3: break; default: usage(); exit(1) }

let option   = CommandLine.arguments[1]

guard option == "-z" || option == "-x" else { usage(); exit(1) } 

// capture filename from command line
let filename = CommandLine.arguments[2]

// create URL object from path string, appending string representation of path component to URL object
guard let fileURL = URL(string: FileManager.default.currentDirectoryPath)?.appendingPathComponent(filename) else { 
    print("\n\(CommandLine.arguments[0]) - cannot open file: \(filename)")
    exit(1)
}

// confirm file exists
guard FileManager.default.fileExists(atPath: fileURL.path) else { 
    print("\n\(CommandLine.arguments[0]) - \(filename) does not exist") 
    exit(1)
} 

// parse [compressed] file

var filedata = String() 

do {
    filedata = try String(contentsOfFile: fileURL.path, encoding: .utf8)
} catch { print(error) }

let tokenList = filedata.components(separatedBy: CharacterSet.whitespaces)

var outputString = ""

if option == "-z" { 
    outputString = compress(tokenList) 
} else if option == "-x" { 
    outputString = uncompress(tokenList) 
}

// write [compressed (.lz78) | uncompressed] file

let outputfile = option == "-z" ? filename + ".lz78" : "uncompressed"

guard let outputdata = outputString.data(using: .utf8) else {
    print("\n\(CommandLine.arguments[0]) - cannot open output file")
    exit(1)
}

let outputURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(outputfile) 

do {
    try  outputdata.write(to: outputURL)
} catch { print(error) }

print("\(outputfile)  written")
