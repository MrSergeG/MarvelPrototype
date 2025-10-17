sub init()
    m.top.functionName = "loadContent"
end sub

sub loadContent()
    m.top.content = createObject("roSGNode", "ContentNode")

    data = []
    data[0] = GetContentByDate("2023-01-01%2C2024-01-02", "2023-2024")
    data[1] = GetContentByDate("2022-01-01%2C2023-01-02", "2022-2023")
    data[2] = GetContentByDate("2021-01-01%2C2022-01-02", "2021-2022")

    numRows = 3

     if data <> invalid then
        for i = 0 to numRows - 1
            row = CreateObject("rosgnode", "ContentNode")
            row.title = data[i].title

            numItems = 5

            for j = 0 to numItems - 1
                item = row.CreateChild("ContentNode")
                item.title = data[i].children[j].title
                ? item.title
                item.id = data[i].children[j].id
                item.description = data[i].children[j].description

                ' TODO: Pass actor data
                actors = []
                for each actor in data[i].children[j].seasons[0]
                    actors.push(actor)
                end for
                item.actors = actors

                item.hdposterurl = data[i].children[j].hdposterurl
            end for
            m.top.content.appendChild(row)
        end for
    end if
    ' if m.top.content <> invalid then
    '     next169Index = 0
    '     num169ContentItems = 16

    '     for i = 0 to numRows - 1
    '         row = CreateObject("rosgnode", "ContentNode")
    '         row.title = "MOVIE ROW " + i.toStr()

    '         numItems = 10

    '         for j = 0 to numItems - 1
    '             item = row.CreateChild("ContentNode")
    '             item.title = "Item " + j.ToStr()

    '             item.hdposterurl = "pkg:/images/16x9/" + next169index.toStr() + ".jpeg"
    '             next169index = (next169index + 1) mod num169ContentItems

    '         end for
    '         m.top.content.appendChild(row)
    '     end for
    ' end if
end sub