package main

import (
	"bufio"
	"bytes"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

const packagefileToken = "packagefile "

var packageMap = make(map[string]map[string]struct{})
var packageSize = make(map[string]int64)

func main() {
	if len(os.Args) < 2 {
		panic("Missing path to builddir")
	}

	matches, err := filepath.Glob(filepath.Join(os.Args[1], "*/*importcfg*"))
	panicOnError(err)
	for _, match := range matches {
		data, err := os.ReadFile(match)
		panicOnError(err)

		scanner := bufio.NewScanner(bytes.NewBuffer(data))
		for scanner.Scan() {
			line := scanner.Text()
			if !strings.HasPrefix(line, packagefileToken) {
				continue
			}

			tokens := strings.Split(line[len(packagefileToken):], "=")
			packageName, packageFile := tokens[0], tokens[1]

			packageFiles, ok := packageMap[packageName]
			if !ok {
				packageFiles = make(map[string]struct{}, 0)
			}
			packageFiles[packageFile] = struct{}{}
			packageMap[packageName] = packageFiles
		}
	}

	for name, files := range packageMap {
		for packagePath := range files {
			fileInfo, err := os.Stat(packagePath)
			panicOnError(err)
			packageSize[name] += fileInfo.Size()
		}
	}

	type packageStat struct {
		name         string
		size         int64
		sizeReadable string
	}

	statSlice := make([]packageStat, 0, len(packageSize))
	for name, size := range packageSize {
		statSlice = append(statSlice, packageStat{name: name, size: size})
	}
	sort.SliceStable(statSlice, func(i, j int) bool { return statSlice[i].size > statSlice[j].size })

	for _, stat := range statSlice {
		println(stat.name, stat.size)
	}
}

func toHumanReadable(size int64) string {
	return ""
}

func panicOnError(err error) {
	if err != nil {
		panic(err)
	}
}
