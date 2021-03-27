GO = go
GOBUILD = $(GO) build
GOTEST = $(GO) test
GOBENCHMARK = $(GOTEST) -bench=. -benchmem
GOTOOL = $(GO) tool

DIST_DIRNAME = ./dist
COVERAGE_FILENAME = ./coverage.html

all: mkdirs build

mkdirs:
	mkdir -p $(DIST_DIRNAME)

build:
	sudo $(GOBUILD) .

run:
	sudo $(GO) run .

test:
	sudo $(GOTEST) -v

pprof:
	sudo $(GOTOOL) pprof exe profile.pprof

coverage:
	sudo $(GOTEST) -coverprofile=coverage.out
	sudo $(GOTOOL) cover -html=coverage.out -o $(COVERAGE_FILENAME)
	sudo rm -f ./coverage.out

clean:
	rm -rf $(DIST_DIRNAME) $(COVERAGE_FILENAME)