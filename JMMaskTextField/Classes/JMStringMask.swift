//
//  JMStringMask.swift
//  JMMaskTextField Swift
//
//  Created by Jota Melo on 02/01/17.
//  Copyright © 2017 Jota. All rights reserved.
//

import Foundation

fileprivate struct Constants {
    static let letterMaskCharacter: Character = "A"
    static let numberMaskCharacter: Character = "0"
    static let alphanumericMaskCharacter: Character = "*"
}

public struct JMStringMask: Equatable {

    var mask: String = ""
    var reverse: Bool = false

    private init() { }

    public init(mask: String, reverse: Bool = false) {
        self.init()
        self.reverse = reverse
        self.mask = mask
    }

    public static func ==(lhs: JMStringMask, rhs: JMStringMask) -> Bool {
        return lhs.mask == rhs.mask
    }

    public func mask(string: String?) -> String? {

        guard let string = string else { return nil }

        if string.count > self.mask.count {
            return nil
        }

        if self.reverse {
            return self.reverseMask(string: string)
        } else {
            return self.normalMask(string: string)
        }
    }

    private func normalMask(string: String) -> String? {

        var formattedString = ""

        var currentMaskIndex = 0
        for i in 0..<string.count {
            if currentMaskIndex >= self.mask.count {
                return nil
            }

            let currentCharacter = string[string.index(string.startIndex, offsetBy: i)]
            var maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]

            if currentCharacter == maskCharacter {
                formattedString.append(currentCharacter)
            } else {
                while (maskCharacter != Constants.letterMaskCharacter
                    && maskCharacter != Constants.numberMaskCharacter
                    && maskCharacter != Constants.alphanumericMaskCharacter) {
                    formattedString.append(maskCharacter)

                    currentMaskIndex += 1
                    maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]
                }

                if maskCharacter != Constants.alphanumericMaskCharacter {
                    let isValidLetter = maskCharacter == Constants.letterMaskCharacter && self.isValidLetterCharacter(currentCharacter)
                    let isValidNumber = maskCharacter == Constants.numberMaskCharacter && self.isValidNumberCharacter(currentCharacter)

                    if !isValidLetter && !isValidNumber {
                        return nil
                    }
                }

                formattedString.append(currentCharacter)
            }

            currentMaskIndex += 1
        }

        return formattedString
    }

    private func reverseMask(string: String) -> String? {

        if string.count >= self.mask.count {
            return nil
        }
        //remove mask characters to mask only original string
        guard let string = self.unmask(string: string) else { return nil }

        var formattedString = ""
        var currentMaskIndex = 0
        var maskCharacterCount = 0
        var reversedMask = ""

        // start mask in last index
        var index = mask.count - 1
        // get last characters of mask, by the count of string
        while maskCharacterCount < string.count {

            let currentMaskCharacter = mask[mask.index(mask.startIndex, offsetBy: index)]

            if (currentMaskCharacter != Constants.letterMaskCharacter
            && currentMaskCharacter != Constants.numberMaskCharacter
                && currentMaskCharacter != Constants.alphanumericMaskCharacter) {
                reversedMask.append(currentMaskCharacter)
            } else {
                reversedMask.append(currentMaskCharacter)
                maskCharacterCount += 1
            }

            index -= 1
        }
        //reverse result mask
        reversedMask = String(reversedMask.reversed())

        for i in 0..<string.count {
            if currentMaskIndex >= self.mask.count {
                return nil
            }

            let currentCharacter = string[string.index(string.startIndex, offsetBy: i)]
            var maskCharacter = reversedMask[reversedMask.index(string.startIndex, offsetBy: currentMaskIndex)]

            if currentCharacter == maskCharacter {
                formattedString.append(currentCharacter)
            } else {
                while (maskCharacter != Constants.letterMaskCharacter
                    && maskCharacter != Constants.numberMaskCharacter
                    && maskCharacter != Constants.alphanumericMaskCharacter) {
                    formattedString.append(maskCharacter)

                    currentMaskIndex += 1
                    maskCharacter = reversedMask[reversedMask.index(string.startIndex, offsetBy: currentMaskIndex)]
                }

                if maskCharacter != Constants.alphanumericMaskCharacter {
                    let isValidLetter = maskCharacter == Constants.letterMaskCharacter && self.isValidLetterCharacter(currentCharacter)
                    let isValidNumber = maskCharacter == Constants.numberMaskCharacter && self.isValidNumberCharacter(currentCharacter)

                    if !isValidLetter && !isValidNumber {
                        return nil
                    }
                }

                formattedString.append(currentCharacter)
            }

            currentMaskIndex += 1
        }

        return formattedString
    }

    public func unmask(string: String?) -> String? {

        guard let string = string else { return nil }
        var unmaskedValue = ""

        for character in string {
            if self.isValidLetterCharacter(character) || self.isValidNumberCharacter(character) {
                unmaskedValue.append(character)
            }
        }

        return unmaskedValue
    }

    private func isValidLetterCharacter(_ character: Character) -> Bool {

        let string = String(character)
        if string.unicodeScalars.count > 1 {
            return false
        }

        let lettersSet = NSCharacterSet.letters
        let unicodeScalars = string.unicodeScalars
        return lettersSet.contains(unicodeScalars[unicodeScalars.startIndex])
    }

    private func isValidNumberCharacter(_ character: Character) -> Bool {

        let string = String(character)
        if string.unicodeScalars.count > 1 {
            return false
        }

        let lettersSet = NSCharacterSet.decimalDigits
        let unicodeScalars = string.unicodeScalars
        return lettersSet.contains(unicodeScalars[unicodeScalars.startIndex])
    }

}
