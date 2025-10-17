function init()

    
end function

function gotContent()
    ? "CharacterListScene->Got Content"
end function

function focusChanged()
    ? "CharacterListScene->Got Focus Change"
end function

function onKeyEvent(key as string, press as boolean) as boolean
    ? "CharacterViewScene->onKey->" + key
    if key = "BACK"
        ? "BACK"
        return true
    end if
    return false
end function
