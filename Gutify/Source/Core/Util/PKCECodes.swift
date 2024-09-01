//
//  PKCEUtil.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation
import Combine
import CommonCrypto

struct PKCECodes {
    
    enum PKCECodesError: Error {
        case generationError
    }
    
    private(set) var codeVerifier: String
    private(set) var codeChallenge: String
    
    init(codeVerifier: String, codeChallenge: String) {
        self.codeVerifier = codeVerifier
        self.codeChallenge = codeChallenge
    }
    
    static func generate() -> Observable<PKCECodes> {
        Future<PKCECodes, Error> {
            let codeVerifier = createCodeVerifier()
            guard let codeChallenge = try? createCodeChallenge(codeVerifier: codeVerifier) else {
                $0(.failure(PKCECodesError.generationError))
                return
            }
            $0(.success(PKCECodes(codeVerifier: codeVerifier,
                                       codeChallenge: codeChallenge)))
        }
        .asObservable()
    }
    
    private static func createCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).pkceEncodedString()
    }
    
    private static func createCodeChallenge(codeVerifier: String) throws -> String {
        guard let data = codeVerifier.data(using: .utf8) else { throw PKCECodesError.generationError }
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> Void in
            _ = CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &buffer)
        }
        return Data(buffer).pkceEncodedString()
    }
    
}

extension Data {
   func pkceEncodedString() -> String {
       return base64EncodedString()
       .replacingOccurrences(of: "+", with: "-")
       .replacingOccurrences(of: "/", with: "_")
       .replacingOccurrences(of: "=", with: "")
       .trimmingCharacters(in: .whitespaces)
   }
}
