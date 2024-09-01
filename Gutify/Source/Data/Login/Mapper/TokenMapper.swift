//
//  TokenMapper.swift
//  Gutify
//
//  Created by Pablo Alonso Gonzalez on 31/8/24.
//

import Foundation

final class TokenMapper: BaseMapper<RefreshTokenResponseDTO, Token> {
    
    override class func transform(_ dataModel: RefreshTokenResponseDTO) throws -> Token {
        Token(accessToken: dataModel.accessToken,
              refreshToken: dataModel.refreshToken)
    }
}
