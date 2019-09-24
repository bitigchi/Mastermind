//
//  ViewController.swift
//  Mastermind
//
//  Created by Emir SARI on 24.09.2019.
//  Copyright © 2019 Emir SARI. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet var tableView: NSTableView!
    @IBOutlet var guess: NSTextField!
    
    var answer = ""
    var guesses = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func submitGuess(_ sender: NSButton) {
        let guessString = guess.stringValue
        guard Set(guessString).count == 4 else { return }
        guard guessString.count == 4 else { return }
        
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guessString.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        guesses.insert(guessString, at: 0)
        tableView.insertRows(at: IndexSet(integer: 0), withAnimation: .slideDown)
        
        let resultString = result(for: guessString)
        if resultString.contains("4b") {
            let alert = NSAlert()
            alert.messageText = "You win!"
            alert.informativeText = "Congratulations. Click OK to play again."
            alert.runModal()
            startGame()
        }
    }
    
    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (index, guessLetter) in guessLetters.enumerated() {
            if guessLetter == answerLetters[index] {
                bulls += 1
            } else if answerLetters.contains(guessLetter) {
                cows += 1
            }
        }
        return "\(bulls)b \(cows)c"
    }
    
    func startGame() {
        guess.stringValue = ""
        guesses.removeAll()
        
        var numbers = Array(0...9)
        numbers.shuffle()
        
        for _ in 0..<4 {
            answer.append(String(numbers.removeLast()))
        }
        
        tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return guesses.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        
        if tableColumn?.title == "Guess" {
            vw.textField?.stringValue = guesses[row]
        } else {
            vw.textField?.stringValue = result(for: guesses[row])
        }
        return vw
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
}

