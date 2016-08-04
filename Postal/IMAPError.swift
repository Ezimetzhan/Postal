//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Snips
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import libetpan

public enum IMAPError {
    case undefinedError
    case connectionError
    case loginError(String)
    case parseError
    case certificateError
    case nonExistantFolderError
}

extension IMAPError: PostalErrorType {
    var asPostalError: PostalError { return .imapError(self) }
}

extension IMAPError {
    func enrich(@noescape f: () -> IMAPError) -> IMAPError {
        if case .undefinedError = self {
            return f()
        }
        return self
    }
}

// MARK: Error code initialization

extension IMAPError: Int32PostalError {
    
    init?(errorCode: Int32) {
        switch Int(errorCode) {
        case MAILIMAP_NO_ERROR, MAILIMAP_NO_ERROR_AUTHENTICATED, MAILIMAP_NO_ERROR_NON_AUTHENTICATED: return nil
        case MAILIMAP_ERROR_STREAM: self = .connectionError
        case MAILIMAP_ERROR_PARSE: self = .parseError
        default: self = .undefinedError
        }
    }
}
