import Foundation

class FakeDataLoader {

    func loadData() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let data: Data? = Data()
            if let data = data {
                continuation.resume(with: .success(data))
            } else {
                continuation.resume(with: .failure(SomeError(description: "Data not exist")))
            }
        }
    }
}
