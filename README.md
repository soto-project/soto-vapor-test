# Soto Vapor Test
Test app for soto. Use this to test if running on ECS, EC2 works

## Docker image

### Creating your docker container

First thing you need to do is create a Docker container. There is a Dockerfile already supplied. You can build the container with the following
```
docker build --tag soto-vapor-test:1.0 .
```
You can test this locally using 
```
docker run -p 8080:8080 soto-vapor-test:1.0
```
With this command line you will find that any AWS communication will fail because the credentials have not been setup. You can test with AWS credentials supplied as environment variables as follows
```
docker run -p 8080:8080 -e AWS_ACCESS_KEY_ID=<my access key> -e AWS_SECRET_ACCESS_KEY=<my secret access key> soto-vapor-test:1.0
```

### Testing the app

The app runs on port 8080. 
- Bring up a web browser and enter `localhost:8080` and it should display the text "It works!". 
- If you enter `localhost:8080/s3` it will display a list of your S3 buckets. 
- If you enter `localhost:8080/s3/<bucket-name>` it will display all the objects in the specified bucket 
- And finally if you enter `localhost:8080/s3/<bucket-name>/<file-name>` it will display details about the specified file.

If you are running this on a public network please don't leave it running as you are exposing the contents of all your S3 buckets to the world.

### Publishing your docker container

The following includes all the steps to make your container available so it can be downloaded on various AWS services.

- Setup an account on hub.docker.com. You can do this from [here](https://hub.docker.com/). 
- Create a new repository for your containers. Click on the "Create Repository" button on the docker home page. Enter the name of the repository. For this it is assumed you are going to use the repository name "soto-vapor-test". 
- Login into docker on the command line using `docker login`.
- Tag your built container
```
docker tag soto-vapor-test:1.0 <your username>/soto-vapor-test:1.0
```
- Upload the container to docker hub
```
docker push <your username>/soto-vapor-test:1.0 
```

### Updating your docker container

Build your docker container as before. It is best to use a new tag so replace the `1.0` with a new version number. You can also take a slight shortcut by using the fullname repository name when building
```
docker build --tag <your username>/soto-vapor-test:1.1 .
```
Once it is built you can upload using the same command as before
```
docker push <your username>/soto-vapor-test:1.0 
```

## Testing on EC2

First you need to setup an IAM role for your EC2 instance. This can be done through the AWS console. Select your EC2 instance, choose "Actions->Instance Settings->Attach/Replace IAM Role". Then choose a role that can read S3 buckets. Log into your EC2 instance and you can install and run the docker container using the following
```
sudo docker run -p 8080:8080 <your username>/soto-vapor-test:1.0
```
Bring up a web browser, type in the IP address of your EC2 instance plus the port `:8080` and you should get the text "It works!". You can then interact with the app as detailed [above](#testing-the-app). 


