.SHELLFLAGS = -ec

COMMIT=$(shell git rev-parse --short HEAD)
IMAGE_NAME="robinnagpal/argo-learning-foo-app:${COMMIT}"

write-commit:
	echo ${COMMIT} > commit.txt

docker-build: write-commit
	docker build . -t ${IMAGE_NAME}

docker-push: docker-build
	docker push ${IMAGE_NAME}

update-k8s-deployment: docker-push
	~/yq eval -i '.spec.template.spec.containers.[0].image=${IMAGE_NAME}' k8s/foo-deployment.yml

commit-circle-update: update-k8s-deployment
	git add .
	git commit -m "[ci skip] [skip ci] Update master version"
	git push origin master

