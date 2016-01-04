require 'CSV'


def getlanguage(data, name)
   return data.select { |x| x[:language] == name }[0]
end
def getLOCCount(lang) 
	csv = CSV.new(File.read("statistics/cloc.csv"), :headers => true, :header_converters => :symbol, :converters => :all)
	data = csv.to_a.map {|row| row.to_hash }

	getlanguage(data, lang)[:code]
end
def generateCLOCCsv()
	`./statistics/cloc-1.64.exe  --exclude-dir=.svn,lib,bin,images,.git  . -csv -out=statistics/cloc.csv`
end
#puts getlanguage(data, "F#")[:code]
#puts getlanguage(data, "Ruby")[:code]
#puts getLOCCound("C#")