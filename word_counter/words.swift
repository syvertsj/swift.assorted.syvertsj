
import Foundation

func usage() { print("usage: \(CommandLine.arguments[0]) [filename]") }

func doWordCount(_ words: [String]) {

    var wordCounter = [String : Int]()
    var topKWords = [String]()
    
    for word in words {
        if word.isEmpty { continue }
        wordCounter[word] = (wordCounter.keys.contains(word) == true) ? wordCounter[word]! + 1 : 1
    }

    // locate words sorting the values in reverse order
    wordCounter.values.sorted().reversed().forEach { (val) in
        wordCounter.keys.sorted().forEach { (key) in
            if wordCounter[key] == val && !topKWords.contains(key) { topKWords.append(key) }
        }
    }

    topKWords.forEach { print($0, wordCounter[$0]!) }
}

// top level code
switch CommandLine.argc { case 2: break; default: usage(); exit(1) }

// capture filename from command line
let filename = CommandLine.arguments[1]

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

// parse file

var filedata = String() 

do {
    filedata = try String(contentsOfFile: fileURL.path, encoding: .utf8)
} catch { print(error) }

let separators = CharacterSet(charactersIn: "\n\r\t:,;.!?-()[]{}|\\<>/~ ")
var tokenList = filedata.lowercased().components(separatedBy: separators)

doWordCount(tokenList)
