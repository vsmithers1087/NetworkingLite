import XCTest
@testable import NetworkingLite

final class NetworkingLiteResponseTests: XCTestCase {
    private let clientMock = NetworkLiteClientMock()
    private let timeout = 8.0
    
    func testResponse() {
        let exp = expectation(description: "Response returns without error")
        clientMock.makeRequest(webServiceConfig: .httpBinGET) { (requestResult) in
            XCTAssertNotNil(requestResult, "request result is nil")
            exp.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSuccessResponseStatusCode() {
        let exp = expectation(description: "Response status code is not 200")
        clientMock.makeRequest(webServiceConfig: .httpBinGET) { (requestResult) in
            switch requestResult {
            case .success(let response):
                XCTAssertNotNil(response, "Response is nil")
                guard let urlResponse = response.response as? HTTPURLResponse else {
                    XCTFail("Response doesn't contain status code")
                    return
                }
                XCTAssertEqual(urlResponse.statusCode, 200)
                exp.fulfill()
            case .error(_):
                XCTFail("Response is error")
            }
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSuccessResponseData() {
        let exp = expectation(description: "Response data is empty")
        clientMock.makeRequest(webServiceConfig: .httpBinBytes(bytes: 1024 * 1024)) { (requestResult) in
            switch requestResult {
            case .success(let response):
                XCTAssertNotNil(response, "Response is nil")
                XCTAssertGreaterThan(response.data.count, 100000)
                exp.fulfill()
            case .error(_):
                XCTFail("Response is error")
            }
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testIsMainThread() {
        let exp = expectation(description: "Response does not return on main thread")
        clientMock.makeRequest(webServiceConfig: .httpBinGET) { (requestResult) in
            XCTAssertEqual(Thread.current, Thread.main)
            exp.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func test404ErrorResult() {
        let exp = expectation(description: "Failed response does not contain error")
        clientMock.makeRequest(webServiceConfig: .httpInvalid) { (requestResult) in
            switch requestResult {
            case .success(_):
                XCTFail("Response is success")
            case .error(let error):
                XCTAssertNotNil(error, "Error is nil")
                XCTAssertEqual(error.statusCode, 404)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: timeout)
    }
}
