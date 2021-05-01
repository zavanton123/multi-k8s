# build the prod images
docker build -t zavanton/multi-client:latest -t zavanton/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t zavanton/multi-server:latest -t zavanton/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t zavanton/multi-worker:latest -t zavanton/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push the prod images to Docker Hub (with the latest tag)
docker push zavanton/multi-client:latest
docker push zavanton/multi-server:latest
docker push zavanton/multi-worker:latest

# push the prod images to Docker Hub (with the git sha tag)
docker push zavanton/multi-client:$SHA
docker push zavanton/multi-server:$SHA
docker push zavanton/multi-worker:$SHA

# apply the k8s configs located in the ./k8s directory
kubectl apply -f k8s

# update the images in the k8s cluster
kubectl set image deployments/server-deployment server=zavanton/multi-server:$SHA
kubectl set image deployments/client-deployment client=zavanton/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=zavanton/multi-worker:$SHA


