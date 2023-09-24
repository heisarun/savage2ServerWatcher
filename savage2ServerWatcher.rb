#! /usr/bin/env ruby

require "nokogiri"                                                                                                        #Ruby XML/HTML parsher.
require "open-uri"     																									#Get Data from Server.
require "time"
require "awesome_print"
require "terminal-table"																							#Need a beautiful way to print server data.

$timer = 0																															#delay running  this script
infinite = true

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
while infinite
							# Fetch and parse HTML document
							document = Nokogiri::HTML(URI.open("https://savage2.net/server"))                       #URL to scrape

							# Search for nodes by xpath
							numberOfTable = document.xpath("//table").length                                                                 #Always returns 1
							numberOftableElements = document.xpath("//tr//td").length                                            #Gives 30 elemental data of server

							table = document.xpath("//table")                                                                                                         #Retrieve table Data
							header = table.xpath("//table//thead")														                                         #Extract only header Data
							headers = header.xpath("//tr//th")                                                                                                        #Extract header names

							identification = headers.xpath("//th")

							identificationLength = identification.length                                                                                     #Length of the header names
							identificationNameStorage = Array.new(identificationLength.to_int)                            #Allocate size of array with the Length of header

							identificationLength.times do |element|
							  identificationNameStorage[element] = identification[element].text.to_s                   #Assign to array , the names of header
							end

							tableBody = table.xpath("//table//tbody")                                                                                       #Extract Table Body
							tableBodyRows = tableBody.xpath("//tbody//tr")
							tableBodyRowsData = tableBody.xpath("//tr//td")
							tableData = tableBodyRows.xpath("//tr")
							tableRowsData = tableData.xpath("//tr//td")

							numberOfTableRows = tableBody.xpath("//tbody//tr").length
							numberOfTableRowsData = tableBody.xpath("//tr//td").length

							serverDataStorage =  Array.new(numberOftableElements)
							eachServerDataStorage = Array.new(numberOfTableRows.to_int) { Array.new(identificationLength.to_int) }

							numberOftableElements.times do |element|
							  serverDataStorage[element] =  tableRowsData[element]
							end


							count = 0
								numberOfTableRows.times do |elementRow|
									identificationLength.times do |elementColumn|
										eachServerDataStorage[elementRow][elementColumn] = serverDataStorage[count]
										count += 1
								end
							end
							count = 0


							computePlayers = Array.new(numberOfTableRows.to_int)
							connectionColumnSelect = identificationNameStorage.find_index("Connections")	 #Column Name (! Warning Hard coded ) for computing Players.

							numberOfTableRows.times do |elementRow|
								identificationLength.times do |elementColumn|
									computePlayers[elementRow] = eachServerDataStorage[elementRow][connectionColumnSelect].text.to_s
								end
							end

							regexGetNumberOfPlayers = /^([0-9]+)/																								# Using regex ,^([0-9]+)     Get one or more numbers

							playerCount = 0
							computePlayers.each do | getPlayers |
								playerCount += getPlayers.match(regexGetNumberOfPlayers)[0].to_i                   # Match data is an array  converting firts array to int  and  applying player-count
							end

							print "\n Players  are  -> "
							print playerCount
							print " \n "

							if playerCount == 0
								$timer = 3600
							elsif playerCount > 0
								$timer = 1800
							elsif playerCount > 8
								$timer = 600
							end

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

							#Un-assign all variables
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																					identificationLength.times do |element|
																					  identificationNameStorage[element] = ""
																					end


																					numberOftableElements.times do |element|
																					  serverDataStorage[element] = ""
																					end

																					count = 0
																						numberOfTableRows.times do |elementRow|
																							identificationLength.times do |elementColumn|
																								eachServerDataStorage[elementRow][elementColumn] = ""
																								count += 1
																						end
																					end
																					count = 0


																					numberOfTableRows.times do |elementRow|
																						identificationLength.times do |elementColumn|
																							computePlayers[elementRow] = ""
																						end
																					end

																					document = ""
																					numberOfTable = 0
																					numberOftableElements = 0
																					table = ""
																					header = ""
																					headers = ""
																					identification = ""
																					identificationLength = 0
																					tableBody  = ""
																					tableBodyRows  = ""
																					tableBodyRowsData  = ""
																					tableData  = ""
																					tableRowsData  = ""
																					numberOfTableRows = 0
																					numberOfTableRowsData = 0
																					count = 0
																					connectionColumnSelect = ""
																					regexGetNumberOfPlayers = ""

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							#End of Un-assign all variables

							print(Time.now())
							sleep($timer)
end
