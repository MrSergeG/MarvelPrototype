function itemContentChanged()
    m.itemPoster.uri = m.top.itemContent.HDPOSTERURL
end function

function init()
    m.itemPoster = m.top.findNode("itemPoster")
end function
