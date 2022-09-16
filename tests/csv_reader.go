package test

import (
	"encoding/csv"
	"log"
	"os"
	"sort"
)

func ReadCsvFileAndReturnListOfValuesFromColumn(filename string, column int) []string {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	csvReader := csv.NewReader(file)
	data, err := csvReader.ReadAll()
	if err != nil {
		log.Fatal(err)
	}

	var records []string
	for i, line := range data {
		if i > 0 {
			records = append(records, line[column])
		}
	}
	sort.Strings(records)
	return records
}
