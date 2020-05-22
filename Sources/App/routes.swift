import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    let s3Controller = S3Controller()
    app.get("s3", use: s3Controller.buckets)
    app.get("s3", ":bucket", use: s3Controller.objects)
    app.get("s3", ":bucket", ":file", use: s3Controller.headObject)
}
