function init()

    
end function

function gotContent()
    ? "CharacterListScene->Got Content"
end function

function focusChanged()
    ? "CharacterListScene->Got Focus Change"
end function

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if key = "BACK"
        handled = true
    end if
    return handled
end function
