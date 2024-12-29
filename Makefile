PROTOFOLDER=./api/addressbook/v1

docker:
	docker build . -t MelleKoning/goproto

# the following generate line is an example that you can
# use in your own repository makefile

generate: docker
	docker run --rm -it -v $(PWD):/app -w /app MelleKoning/goproto protoc --go_out=$(PROTOFOLDER) $(PROTOFOLDER)/*.proto


.PHONY: docker generate
