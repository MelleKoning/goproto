# goproto

goproto to generate golang from proto files

## Introduction

When programming with GoLang we can define interfaces to interact with other applications using [Protocol Buffers](https://protobuf.dev/). There are different versions of generating golang code from protocol buffers, and when programming on different devices, potentially having different versions of these generators and/or validators, we need a way to pinpoint to a certain version to harmonize development over multiple devices (or developers).

This repository is aimed to do just that. By providing a docker image having a particular version of the protocol buffer generator (and potentially other accompanying tools) we ensure that we use the same versions.

## Suggest enhancements

For help in syntax checking and writing the markdown, the repository makes use of [Pre-commit](https://pre-commit.com/). How to install this tool on your environment is out of scope for this documentation, but it is assumed you have pre-commit installed if you want to contribute to this repository. Please ensure to run `pre-commit run -a` before suggesting an update via a pull request.

## Example addressbook.proto

The `addressbook.proto` example is copied from [protobuf buffers basics:GO tutorial](https://protobuf.dev/getting-started/gotutorial/)

You can (re-)generate the `addressbook.pb.go` file by running the consecutive commands:

`make docker` -> creates the docker image with the protocol buffers golang tooling
`make generate` -> uses the generated docker image with the go protobuffers tooling

The above tutorial also shows the way the generated golang structs can then be used to Marshal and Unmarshal data for writing to files.

We also added a simple remote procedure call to retrieve the contents of the entire addressbook, this is for ensuring the grpc stubs are also created.

## buf linter

With the `pre-commit` hook `buf-lint` we also have a validator for the `addressbook.proto` file. This one ensures that all proto messages and proto fields are validated against certain expected proto standards. Pre-commit will install `buf` as the pre-commit hook, you can also install [buf](https://buf.build/docs/) yourself on your machine and run the command `buf lint` in the root, it will take the example `.buf.yaml` as the configuration to check the default `addressbook.proto`. If anything is wrong in messages or fieldsnames, `buf` will tell you about that.
