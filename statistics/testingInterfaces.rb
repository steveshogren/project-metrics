
def clean(a)
  if(a == nil) then return nil end
  a = a.strip
  if(a == ":" || a == "interface" || a == "not" || a == "grep") then return nil end
  return a
end

def onlyforTesting(i) 
	# countsOfInterface = `git grep \": *#{i}\" | grep \"\\.cs\" | wc -l`
	c  = "git grep \":.*#{i}\" -- \"*.cs\" | wc -l"
	result = `#{c}`
  if (result == nil) 
    return "" 
  end
  return result.strip
end

def collectSingleInstanceInterfaces()
  allInterfaces = `git grep \"public interface\" | grep \"\\.cs\"`
  t = allInterfaces.split(/\r?\n/ ).map{|r| clean(r.split(" ")[3])}
  results = t.map { |a| if (a != nil) then 
                          count = onlyforTesting(a).to_s 
                          if (count == "1") then a + " - " + count
                          else "" end
                        else "" end }
  onlyOneResult = results.select { |r| r.strip != "" } 
  return onlyOneResult.count
end
