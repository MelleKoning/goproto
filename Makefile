PROTOFOLDER=./api/addressbook/v1
# we have to run the docker as the current user so that
# generated files by the docker container are having
# the same owner - otherwise we risk setting the owner
# on the file of the docker service which might be root
USERID=$(shell id -u)
USERGROUP=$(shell id -g)

GOCACHEDIR=$(shell go env GOCACHE)

docker:
	docker build . -t MelleKoning/goproto

# the following generate line is an example that you can
# use in your own repository makefile

generate: docker
# docker run --user $(USERID):$(USERGROUP) --rm -it -v $(PWD):/app -w /app MelleKoning/goproto protoc --go_out=$#(PROTOFOLDER) --go-grpc_out=. --go-grpc_opt=paths=source_relative $(PROTOFOLDER)/*.proto
#	docker run --user $(USERID):$(USERGROUP) --rm -it -v $(PWD):/app -w /app MelleKoning/goproto go generate ./...
#	docker run --user 1000:1000 --rm -it -v $(GOCACHEDIR):/gocache -v $(PWD):/app -w /app -e GOCACHE=/gocache/ MelleKoning/goproto go generate -v ./...
	docker run -v $(PWD):/app -w /app MelleKoning/goproto go generate ./...

.PHONY: docker generate
