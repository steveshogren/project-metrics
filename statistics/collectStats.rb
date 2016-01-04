#!/bin/ruby


# todo
# - LOC counts # ./cloc-1.64.exe  --exclude-dir=.svn,lib,bin,images  ../ -csv -out=cloc.csv
# - Interface not for polymorphism # git grep 'public interface' | grep "\.cs" | awk '{print $4}' | wc -l
# - Cyclomatic complexity
# - Style violations
# - 
require 'erb'
require 'yaml'
require_relative 'parseCsv.rb'
require_relative 'testingInterfaces.rb'

which = ARGV[0]


def makeTemp(number)
  date = Time.new.strftime("%Y-%m-%d")
  return ",['#{date}',#{number.strip}]"
end

def onLoadCallbacks(name, id, data) 
	 return "google.setOnLoadCallback(function(){ 
              createChart('#{name}','#{id}', 
              [#{data}])
            });\n"
end

def chartDivs(id)
	return "<div style=\"float:left\" id=\"#{id}\"></div>\n"
end

if (which == "generateYml") 
	findalls =  `git grep \"\\.FindAll(\" | grep -vE \"Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson|packages|lib|Designer\" | grep \"\\.cs:\" | wc -l`
	finds = `git grep  \"\\.Find(\" | grep -vE \"Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson|packages|lib|Designer\" | grep \"\\.cs:\" | wc -l`
	save = `git grep  \"\\.Save(\" | grep -vE \"Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson|packages|lib|Designer\" | grep \"\\.cs:\" | wc -l`
	ids = `git grep  -w \"Identifier\" | grep -vE \"Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson\" | grep \"\\.cs:\" | wc -l `

	generateCLOCCsv()
	csharpcloc = getLOCCount("C#").to_s
  singleInterfaceCount = collectSingleInstanceInterfaces().to_s

	puts "C# cloc " + csharpcloc
	puts "findalls" + findalls
	puts "finds" + finds
	puts "save" + save
	puts "ids" + ids
	puts "singleInterfaceCount" + singleInterfaceCount
	
	template = ERB.new(File.read("statistics/chart.html"))
	d = YAML::load_file('statistics/data.yml') 
	d['ids'] = d['ids'].to_s + makeTemp(ids)
	d['findalls'] = d['findalls'].to_s + makeTemp(findalls)
	d['finds'] = d['finds'].to_s + makeTemp(finds)
	d['save'] = d['save'].to_s + makeTemp(save)
	d['csharp'] = d['csharp'].to_s + makeTemp(csharpcloc)
	d['singleInterfaceCount'] = d['singleInterfaceCount'].to_s + makeTemp(singleInterfaceCount)
	File.open('statistics/data.yml', 'w') {|f| f.write d.to_yaml } 
end

if (which == "makeCharts") 
	template = ERB.new(File.read("statistics/chart.html"))
	d = YAML::load_file('statistics/data.yml') 
	ids = d['ids']
	finds = d['finds']
	save = d['save']
	findalls = d['findalls']
	csharp = d['csharp']
	singleInterfaceCount = d['singleInterfaceCount'] 
	onLoadCallbacks = onLoadCallbacks("Identifier Counts", "idchart", ids)    + onLoadCallbacks("Wilson Find Counts", "findchart", finds)    + onLoadCallbacks("Wilson Find All Counts", "findallchart", findalls)    + onLoadCallbacks("Wilson Save Counts", "savechart", save)   + onLoadCallbacks("C# Cloc", "csharpchart", csharp)   + onLoadCallbacks("Single Use Interfaces", "singleUseInterfaces", singleInterfaceCount)
	chartDivs = chartDivs("idchart") + chartDivs("findchart") + chartDivs("findallchart") + chartDivs("savechart") + chartDivs("csharpchart") + chartDivs("singleUseInterfaces")
	File.open('statistics/chartWithData.html', 'w') {|f| f.write template.result } 
end
