import AWSS3
import Vapor

class S3Controller {
    let s3 = S3(region: .euwest1)
    
    func buckets(_ req: Request) -> EventLoopFuture<[String]> {
        return s3.listBuckets().map { output in
            return output.buckets?.compactMap { $0.name } ?? []
        }.flatMapErrorThrowing { error in
            if let error = error as? AWSErrorType {
                throw Abort(.badRequest, reason: error.description)
            }
            throw error
        }
    }
    
    func objects(_ req: Request) -> EventLoopFuture<[String]> {
        let bucket = req.parameters.get("bucket")!
        let request = S3.ListObjectsRequest(bucket: bucket, maxKeys: 100)
        return s3.listObjects(request).map { output in
            return output.contents?.compactMap { $0.key } ?? []
        }.flatMapErrorThrowing { error in
            if let error = error as? AWSErrorType {
                throw Abort(.badRequest, reason: error.description)
            }
            throw error
        }
    }
}
