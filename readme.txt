docker build -t gmanal1005/hello-python:1.0.0 .

docker push gmanal1005/hello-python:1.0.0

docker run -d -p 9000:9000 gmanal1005/hello-python:1.0.0