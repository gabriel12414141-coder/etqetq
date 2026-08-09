local function FindFruitRoot(object)

	if not object then
		return nil, nil
	end

	local current = object

	for _ = 1, 6 do

		if not current then
			break
		end

		local fruitName =
			IdentifyExactFruitName(current.Name)

		if fruitName then
			return current, fruitName
		end

		local attributeFruit =
			IdentifyFromAttributes(current)

		if attributeFruit then
			return current, attributeFruit
		end

		current = current.Parent
	end

	return nil, nil
end


local function CheckObject(object, showNotification)

	if not object then
		return
	end

	if not object.Parent then
		return
	end

	-- Procura o verdadeiro container da fruta
	local fruitRoot, fruitName =
		FindFruitRoot(object)

	if not fruitRoot then
		return
	end

	-- Se já registramos o Model/Tool principal,
	-- não registra novamente seus filhos.
	if Fruits[fruitRoot] then
		return
	end

	local part =
		GetFruitPart(fruitRoot)

	if not part then
		return
	end

	local distance =
		GetDistance(fruitRoot)

	if distance > MAX_DISTANCE then
		return
	end

	Fruits[fruitRoot] = {

		Object = fruitRoot,

		Name = fruitName,

		Distance = distance,
	}

	CreateMarker(
		fruitRoot,
		fruitName
	)

	if showNotification then

		Notify(
			fruitName,
			distance
		)

	end

	ListDirty = true
end
