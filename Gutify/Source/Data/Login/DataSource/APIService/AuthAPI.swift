//
// AlbumsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
open class AuthAPI {

    public static let basePath = GutifyConstants.authAPI
    
    open class func requestAccessToken(codeVerifier: String,
                                       authorizationCode: String) -> RequestBuilder<RefreshTokenResponseDTO> {
        let localVariablePath = "/api/token"
        let localVariableURLString = AuthAPI.basePath + localVariablePath

        let localVariableFormParams: [String: Any?] = [
            "client_id": GutifyConstants.clientID.encodeToJSON(),
            "grant_type": "authorization_code".encodeToJSON(),
            "redirect_uri": GutifyConstants.redirectUri.encodeToJSON(),
            "code_verifier": codeVerifier.encodeToJSON(),
            "code": authorizationCode.encodeToJSON(),
        ]
        
        let localVariableNonNullParameters = APIHelper.rejectNil(localVariableFormParams)
        let localVariableParameters = APIHelper.convertBoolToString(localVariableNonNullParameters)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<RefreshTokenResponseDTO>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST",
                                                URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
                                                parameters: localVariableParameters,
                                                headers: localVariableHeaderParameters)
    }
    
    open class func requestRefreshToken(refreshToken: String) -> RequestBuilder<RefreshTokenResponseDTO> {
        let localVariablePath = "/api/token"
        let localVariableURLString = AuthAPI.basePath + localVariablePath

        let localVariableFormParams: [String: Any?] = [
            "client_id": GutifyConstants.clientID.encodeToJSON(),
            "grant_type": "refresh_token".encodeToJSON(),
            "refresh_token": refreshToken.encodeToJSON(),
        ]
        
        let localVariableNonNullParameters = APIHelper.rejectNil(localVariableFormParams)
        let localVariableParameters = APIHelper.convertBoolToString(localVariableNonNullParameters)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<RefreshTokenResponseDTO>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST",
                                                URLString: (localVariableUrlComponents?.string ?? localVariableURLString),
                                                parameters: localVariableParameters,
                                                headers: localVariableHeaderParameters)
    }
}
