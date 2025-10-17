'********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

function init()
    m.characterMarkupList = m.top.findNode("CharacterMarkupList")
    m.characterMarkupList.content = getMarkupListData()
    m.characterMarkupList.SetFocus(true)
	m.characterMarkupList.ObserveField("itemFocused", "onFocusChanged")
end function

function getMarkupListData() as object
    data = CreateObject("roSGNode", "ContentNode")

    title = "A-Bomb (HAS)"
    hdposterurl = "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"
    description = "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction! "

    for i = 1 to 6
        dataItem = data.CreateChild("CharacterListItemData")
        dataItem.posterUrl = hdposterurl
        dataItem.labelText = title
        dataItem.label2Text = description
    end for
    return data
end function

function onFocusChanged() as void
    print "Focus on item: " + stri(m.characterMarkupList.itemFocused)
    print "Focus on item: " + stri(m.characterMarkupList.itemUnfocused) + " lost"
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    ? "CharView Key"
    handled = false
    if (m.characterMarkupList.hasFocus() = true) and (key = "right") and (press=true)
	    m.characterMarkupList.setFocus(true)
		m.characterMarkupList.setFocus(false)
	    handled = true
    else if key = "OK"'
       
	endif
    return handled    
end function
