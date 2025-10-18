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
    description = "Rick Jones has been Hulk's..."

    mockData = GetCharacterMockData()

    for i = 0 to 5
        dataItem = data.CreateChild("CharacterListItemData")
        dataItem.posterUrl = mockData[i].hdposterurl
        dataItem.labelText = mockData[i].title
        dataItem.label2Text = mockData[i].description
    end for
    return data
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if (m.characterMarkupList.hasFocus() = true) and (key = "right") and (press=true)
	    m.characterMarkupList.setFocus(true)
		m.characterMarkupList.setFocus(false)
	    handled = true
    else if key = "OK"'
       
	endif
    return handled    
end function
