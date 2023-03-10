---[[

	--------------------------------------------------------------------

	Version 1.5

	Aqwam's Roblox Matrix Library (AR-MatrixL)

	Author: Aqwam Harish Aiman
	
	YouTube: https://www.youtube.com/channel/UCUrwoxv5dufEmbGsxyEUPZw
	
	LinkedIn: https://www.linkedin.com/in/aqwam-harish-aiman/
	
	--------------------------------------------------------------------
	
	DO NOT SELL, RENT, DISTRIBUTE THIS LIBRARY
	
	DO NOT SELL, RENT, DISTRIBUTE MODIFIED VERSION OF THIS LIBRARY
	
	DO NOT CLAIM OWNERSHIP OF THIS LIBRARY
	
	GIVE CREDIT AND SOURCE WHEN USING THIS LIBRARY IF YOUR USAGE FALLS UNDER ONE OF THESE CATEGORIES:
	
		- USED AS A VIDEO OR ARTICLE CONTENT
		- USED AS COMMERCIAL OR PUBLIC USE 
	
	--------------------------------------------------------------------

--]]

local libraryVersion = 1.5

local MatrixOperation = require(script.MatrixOperation)
local MatrixBroadcast = require(script.MatrixBroadcast)
local MatrixDotProduct = require(script.MatrixDotProduct)
local MatrixConcatenate = require(script.MatrixConcatenate)

local AqwamRobloxMatrixLibrary = {}

local function convertToMatrixIfScalar(value)

	local isNotScalar

	isNotScalar = pcall(function()

		local testForScalar = value[1][1]

	end)
	
	if not isNotScalar then
		
		return {{value}}
		
	else
		
		return value
		
	end
	
end

local function generateArgumentErrorString(matrices, firstMatrixIndex, secondMatrixIndex)
	
	local text1 = "Argument " .. secondMatrixIndex .. " and " .. firstMatrixIndex .. " are incompatible! "

	local text2 = "(" ..  #matrices[secondMatrixIndex] .. ", " .. #matrices[secondMatrixIndex][1] .. ") and " .. "(" ..  #matrices[firstMatrixIndex] .. ", " .. #matrices[firstMatrixIndex][1] .. ")"
	
	local text = text1 .. text2
	
	return text
	
end

local function broadcastAndCalculate(operation, ...)
	
	local matrices = {...}
	
	local firstMatrixIndex = #matrices
	local secondMatrixIndex = firstMatrixIndex - 1 

	local matrix1 = convertToMatrixIfScalar(matrices[firstMatrixIndex])

	local matrix2 = convertToMatrixIfScalar(matrices[secondMatrixIndex])
	
	matrix1, matrix2 = MatrixBroadcast:matrixBroadcast(matrix1, matrix2)

	local result
	
	local success = pcall(function()

		result = MatrixOperation:matrixOperation(operation, matrix1, matrix2)

	end)

	if (not success) then
		
		local text = generateArgumentErrorString(matrices, firstMatrixIndex, secondMatrixIndex)

		error(text)

	end

	if ( (secondMatrixIndex - 1) > 0) then

		return broadcastAndCalculate(operation, select(secondMatrixIndex - 1, ...), result)

	else

		return result

	end
	
end

function AqwamRobloxMatrixLibrary:add(...)
	
	return broadcastAndCalculate('+', ...)
	
end

function AqwamRobloxMatrixLibrary:subtract(...)

	return broadcastAndCalculate('-', ...)

end

function AqwamRobloxMatrixLibrary:multiply(...)

	return broadcastAndCalculate('*', ...)

end

function AqwamRobloxMatrixLibrary:divide(...)

	return broadcastAndCalculate('/', ...)

end

function AqwamRobloxMatrixLibrary:logarithm(...)

	return broadcastAndCalculate('log', ...)

end

function AqwamRobloxMatrixLibrary:exp(...)

	return broadcastAndCalculate('exp', ...)

end

function AqwamRobloxMatrixLibrary:power(...)

	return broadcastAndCalculate('power', ...)

end

function AqwamRobloxMatrixLibrary:areValuesEqual(...)

	return broadcastAndCalculate('==', ...)

end

function AqwamRobloxMatrixLibrary:areValuesGreater(...)

	return broadcastAndCalculate('>', ...)

end

function AqwamRobloxMatrixLibrary:areValuesGreaterOrEqual(...)

	return broadcastAndCalculate('>=', ...)

end

function AqwamRobloxMatrixLibrary:areValuesLesser(...)

	return broadcastAndCalculate('<', ...)

end

function AqwamRobloxMatrixLibrary:areValuesLesserOrEqual(...)

	return broadcastAndCalculate('<=', ...)

end

function AqwamRobloxMatrixLibrary:areMatricesEqual(...)

	local resultMatrix = broadcastAndCalculate('==', ...)
	
	for row = 1, #resultMatrix, 1 do
		
		for column = 1, #resultMatrix[1], 1 do
			
			if (resultMatrix[row][column] == false) then return false end
			
		end
		
	end
	
	return true

end

function AqwamRobloxMatrixLibrary:dotProduct(...)

	local matrices = {...}
	
	local firstMatrixIndex = #matrices
	local secondMatrixIndex = firstMatrixIndex - 1 

	local result
	
	local success = pcall(function()
		
		result = MatrixDotProduct:dotProduct(matrices[secondMatrixIndex], matrices[firstMatrixIndex])
		
	end)
	
	if (not success) then
		
		local text = generateArgumentErrorString(matrices, firstMatrixIndex, secondMatrixIndex)

		error(text)
		
	end
	
	if ( (secondMatrixIndex - 1) > 0) then
		
		return AqwamRobloxMatrixLibrary:dotProduct(select(secondMatrixIndex - 1, ...), result)

	else
		
		return result

	end

end

function AqwamRobloxMatrixLibrary:sum(matrix)
	
	local result = 0
	
	local matrixRows = #matrix
	local matrixColumns = #matrix[1]
	
	for row = 1, matrixRows, 1 do
		
		for column = 1, matrixColumns, 1 do
			
			result += matrix[row][column]
			
		end
		
	end
	
	return result
	
end

function AqwamRobloxMatrixLibrary:createIdentityMatrix(numberOfRowsAndColumns)
	
	local result = {}
	
	for row = 1, numberOfRowsAndColumns, 1 do
		
		result[row] = {}
		
		for column = 1, numberOfRowsAndColumns, 1 do
				
			if (row == column) then
					
				result[row][column] = 1
					
			else
					
				result[row][column] = 0
					
			end
				
		end
		
	end
	
	return result
	
end

function AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, numberOfColumns, allNumberValues)
	
	allNumberValues = allNumberValues or 0
	
	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			result[row][column] = allNumberValues

		end	

	end

	return result
	
end

function AqwamRobloxMatrixLibrary:createRandomMatrix(numberOfRows, numberOfColumns)

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do

			result[row][column] = Random.new():NextInteger(-100000, 100000)

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:createRandomNormalMatrix(numberOfRows, numberOfColumns)

	local result = {}

	for row = 1, numberOfRows, 1 do

		result[row] = {}

		for column = 1, numberOfColumns, 1 do
			
			result[row][column] = Random.new():NextNumber()

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:getSize(matrix)
	
	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]
	
	return {numberOfRows, numberOfColumns}
	
end


function AqwamRobloxMatrixLibrary:transpose(matrix)
	
	local currentRowVector
	
	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]
	
	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfColumns, numberOfRows)
	
	for row = 1, numberOfRows, 1 do
		
		currentRowVector = matrix[row]
		
		for column = 1, #currentRowVector, 1 do
			
			result[column][row] = currentRowVector[column]
			
		end
		
	end
	
	return result
	
end

function AqwamRobloxMatrixLibrary:verticalSum(matrix)
	
	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(1, numberOfColumns)

	for row = 1, numberOfRows, 1 do
		
		for column = 1, numberOfColumns, 1 do

			result[1][column] += matrix[row][column]

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:horizontalSum(matrix)

	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, 1)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do

			result[row][1] += matrix[row][column]

		end	

	end

	return result

end

function AqwamRobloxMatrixLibrary:mean(matrix)

	local sum = 0

	local numberOfElements = #matrix * #matrix[1]
	
	local sum = AqwamRobloxMatrixLibrary:sum(matrix)

	local mean = sum/numberOfElements

	return mean

end

function AqwamRobloxMatrixLibrary:verticalMean(matrix)

	local numberOfRows = #matrix

	local verticalSum = AqwamRobloxMatrixLibrary:verticalSum(matrix)
	
	local result = AqwamRobloxMatrixLibrary:divide(verticalSum, numberOfRows) 

	return result

end

function AqwamRobloxMatrixLibrary:horizontalMean(matrix)

	local numberOfColumns = #matrix[1]

	local horizontalSum = AqwamRobloxMatrixLibrary:horizontalSum(matrix)
	
	local result = AqwamRobloxMatrixLibrary:divide(horizontalSum, numberOfColumns)

	return result

end

function AqwamRobloxMatrixLibrary:standardDeviation(matrix)

	local mean = AqwamRobloxMatrixLibrary:mean(matrix)

	local numberOfElements = #matrix * #matrix[1]

	local sum = 0

	local squaredSum

	local standardDeviation

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do

			sum += matrix[row][column] - mean

		end

	end

	squaredSum = sum^2

	standardDeviation = math.sqrt(squaredSum/numberOfElements)

	return standardDeviation	

end

function AqwamRobloxMatrixLibrary:verticalStandardDeviation(matrix)
	
	local verticalMean = AqwamRobloxMatrixLibrary:verticalMean(matrix)
	
	local matrixSubtractedByMean = AqwamRobloxMatrixLibrary:createMatrix(#matrix, #matrix[1])
	
	for row = 1, #matrix, 1 do
		
		for column = 1, #matrix[1], 1 do
			
			matrixSubtractedByMean[row][column] = matrix[row][column] - verticalMean[1][column]
			
		end
		
	end
	
	local squaredMatrixSubtractedByMean = AqwamRobloxMatrixLibrary:power(matrixSubtractedByMean, 2)
	
	local dividedMatrix = AqwamRobloxMatrixLibrary:divide(squaredMatrixSubtractedByMean, #matrix)
	
	local squareRootMatrix = AqwamRobloxMatrixLibrary:power(dividedMatrix, (1/2))
	
	return squareRootMatrix
	
end

function AqwamRobloxMatrixLibrary:horizontalStandardDeviation(matrix)

	local horizontalMean = AqwamRobloxMatrixLibrary:horizontalMean(matrix)

	local matrixSubtractedByMean = AqwamRobloxMatrixLibrary:createMatrix(#matrix, #matrix[1])

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do

			matrixSubtractedByMean[row][column] = matrix[row][column] - horizontalMean[row][1]

		end

	end

	local squaredMatrixSubtractedByMean = AqwamRobloxMatrixLibrary:power(matrixSubtractedByMean, 2)

	local dividedMatrix = AqwamRobloxMatrixLibrary:divide(squaredMatrixSubtractedByMean, #matrix[1])

	local squareRootMatrix = AqwamRobloxMatrixLibrary:power(dividedMatrix, (1/2))

	return squareRootMatrix

end

local function generateMatrixString(matrix)
	
	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local text = ""

	for row = 1, numberOfRows, 1 do

		text = text .. "{"

		for column = 1, numberOfColumns, 1 do

			text = text .. "\t" .. matrix[row][column]

		end

		text = text .. "\t}\n"

	end
	
	return text
	
end

function AqwamRobloxMatrixLibrary:printMatrix(...)
	
	local text = "\n\n"
	
	local generatedText
	
	local matrices = {...}
	
	for matrixNumber = 1, #matrices, 1 do
		
		generatedText = generateMatrixString(matrices[matrixNumber])
		
		text = text .. generatedText
		
		text = text .. "\n"
		
	end

	print(text)
	
end

function AqwamRobloxMatrixLibrary:horizontalConcatenate(...)

	local matrices = {...}

	local firstMatrixIndex = #matrices
	local secondMatrixIndex = firstMatrixIndex - 1 

	local result

	local success = pcall(function()

		result = MatrixConcatenate:horizontalConcatenate(matrices[secondMatrixIndex], matrices[firstMatrixIndex])

	end)

	if (not success) then

		local text = generateArgumentErrorString(matrices, firstMatrixIndex, secondMatrixIndex)

		error(text)

	end

	if ( (secondMatrixIndex - 1) > 0) then

		return AqwamRobloxMatrixLibrary:horizontalConcatenate(select(secondMatrixIndex - 1, ...), result)

	else

		return result

	end
	
end

function AqwamRobloxMatrixLibrary:verticalConcatenate(...)

	local matrices = {...}

	local firstMatrixIndex = #matrices
	local secondMatrixIndex = firstMatrixIndex - 1 

	local result

	local success = pcall(function()

		result = MatrixConcatenate:verticalConcatenate(matrices[secondMatrixIndex], matrices[firstMatrixIndex])

	end)

	if (not success) then

		local text = generateArgumentErrorString(matrices, firstMatrixIndex, secondMatrixIndex)

		error(text)

	end

	if ( (secondMatrixIndex - 1) > 0) then

		return AqwamRobloxMatrixLibrary:verticalConcatenate(select(secondMatrixIndex - 1, ...), result)

	else

		return result

	end

end


function AqwamRobloxMatrixLibrary:applyFunction(functionToApply, ...)
	
	local matricesValues
	
	local matrices = {...}
	local matrix = matrices[1]
	
	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]

	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, numberOfColumns)

	for row = 1, numberOfRows, 1 do

		for column = 1, numberOfColumns, 1 do
			
			matricesValues = {}
			
			for matrixArgument = 1, #matrices, 1  do
				
				table.insert(matricesValues, matrices[matrixArgument][row][column])
				
			end 

			result[row][column] = functionToApply(table.unpack(matricesValues))

		end	

	end

	return result
	
end

function AqwamRobloxMatrixLibrary:findMaximumValueInMatrix(matrix)
	
	local maximumValue = -math.huge
	
	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do
			
			maximumValue = math.max(maximumValue, matrix[row][column])

		end

	end
	
	return maximumValue
	
end

function AqwamRobloxMatrixLibrary:findMinimumValueInMatrix(matrix)

	local minimumValue = math.huge

	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do

			minimumValue = math.min(minimumValue, matrix[row][column])

		end

	end

	return minimumValue

end

function AqwamRobloxMatrixLibrary:normalizeMatrix(matrix)
	
	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]
	
	local result = AqwamRobloxMatrixLibrary:createMatrix(numberOfRows, numberOfColumns)
	
	local maximumValue = AqwamRobloxMatrixLibrary:findMaximumValueInMatrix(matrix)
	
	local minimumValue = AqwamRobloxMatrixLibrary:findMinimumValueInMatrix(matrix)
	
	for row = 1, #matrix, 1 do

		for column = 1, #matrix[1], 1 do

			result[row][column] = (matrix[row][column] - minimumValue) / (maximumValue - minimumValue)

		end

	end

	return result

end

function AqwamRobloxMatrixLibrary:getVersion()
	
	return libraryVersion
	
end

return AqwamRobloxMatrixLibrary
