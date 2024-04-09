//
//  LoginViewModelTests.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 4/9/24.
//

import XCTest
import AuthenticationServices

final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!
    var mockAuthService: MockAuthService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAuthService = MockAuthService()
        viewModel = LoginViewModel(authService: mockAuthService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAuthService = nil
        try super.tearDownWithError()
    }

    func testAuthenticateSuccess() {
        // Assuming your mock auth service can simulate success
        mockAuthService.shouldAuthenticateSuccessfully = true
        
        
        let expectation = XCTestExpectation(description: "Successful authentication changes log_Status to true")
        let dummyCredential = DummyAppleIDCredential()
        //viewModel.authenticate(credential: dummyCredential)
        
        // Wait for async code to execute
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.log_Status)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

}


class MockAuthService: AuthServiceProtocol {
    var shouldAuthenticateSuccessfully: Bool = false
    var error: Error?

    func signIn(withCredential credential: AppleIDCredentialProtocol, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldAuthenticateSuccessfully {
            completion(.success(()))
        } else {
            completion(.failure(error ?? NSError(domain: "MockAuthServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mocked error"])))
        }
    }
}


class DummyAppleIDCredential: AppleIDCredentialProtocol {
    var user: String = "dummyUser"
    var identityToken: Data? = "dummyToken".data(using: .utf8)
    var authorizationCode: Data? = "dummyCode".data(using: .utf8)
}



protocol AuthServiceProtocol {
    func signIn(withCredential credential: AppleIDCredentialProtocol, completion: @escaping (Result<Void, Error>) -> Void)
}



protocol AppleIDCredentialProtocol {
    var user: String { get }
    var identityToken: Data? { get }
    var authorizationCode: Data? { get }

}
extension ASAuthorizationAppleIDCredential: AppleIDCredentialProtocol {}
