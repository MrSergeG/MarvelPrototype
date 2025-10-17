function init()

    m.comicGridView = m.top.findNode("comicGridView")
    m.characterListView = m.top.findNode("characterListView")
    m.characterListView.visible = false

    setupComicGridView()
    createVideoPlayer()

    m.top.visible = true
    m.top.observeField("focusedChild", "focusChanged")

end function

sub createVideoPlayer()
    m.video = m.top.createChild("Video")
    m.video.id = "video"
    m.video.width = "1280"
    m.video.height = "720"
    m.video.translation = "[0,0]"
    m.video.enableUI = "true"
    m.video.disableScreenSaver = m.top.disableScreenSaver
    m.video.visible = false
end sub

sub setupComicGridView()
    m.comicTitleLabel = m.comicGridView.findNode("comicDescriptionLabel")
    m.zoomRowList = m.comicGridView.findNode("comicZoomRowList")

    m.zoomRowList.translation = [80, 110]

    m.zoomRowList.observeField("scrollingStatus", "scrollingStatusChanged")
    m.zoomRowList.observeField("rowItemFocused", "rowItemFocusedChanged")
    m.zoomRowList.observeField("rowFocused", "rowFocusedChanged")

    m.readerTask = createObject("roSGNode", "LoadContentTask")
    m.readerTask.observeField("content", "gotContent")
    m.readerTask.control = "RUN"

    m.zoomRowList.visible = false
    m.zoomRowList.setFocus(true)
end sub

function gotContent()
    if m.readerTask.content = invalid
        print "invalid readerTask.content"
    else
        m.zoomRowList.content = m.readerTask.content
        m.zoomRowList.visible = true
    end if
end function

function focusChanged()
    if m.top.isInFocusChain()
        if not m.zoomRowList.hasFocus()
            m.zoomRowList.setFocus(true)
        end if
    end if
end function

function rowItemFocusedChanged()
    item = m.zoomRowList.content.getChild(m.zoomRowList.rowItemFocused[0])
    title = item.getchild(m.zoomRowList.rowItemFocused[1]).title
    m.comicTitleLabel.text = title
end function

sub playVideo()
    m.video.visible = true
    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

    m.video.content = videoContent
    m.video.control = "play"
end sub

sub setCharacterViewVisible()
    m.characterListView.visible = true
    m.comicGridView.visible = false
    markupL = m.characterListView.findNode("CharacterMarkupList")
    markupL.setFocus(true)
end sub

sub setComicViewVisible()
    m.characterListView.visible = false
    m.comicGridView.visible = true
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if key = "OK"
        if m.characterListView.visible = true
            playVideo()
        end if

        setCharacterViewVisible()

        handled = true
    else if key = "back" and press
        if m.video.visible = true
            m.video.control = "stop"
            m.video.visible = false
            
            setCharacterViewVisible()
       else
            setComicViewVisible()
        end if    

        handled = true
    end if
    return handled
end function
