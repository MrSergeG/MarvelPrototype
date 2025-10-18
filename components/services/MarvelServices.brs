function GetServiceCongfig() as Object
return {
        publicApiKey: "225a6641c893e5d08a0db02a3ee4c4eb",
        privateApiKey: "4881cebb8662136862ab48f72d040282a0f65554",
        mockData: true,
        mockPlayerUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    }
end function

function generateServiceHash() as String
    ' Generate the unique hash require by the service
    ' The has is generated using an MD5 hash of the time stamp, private key and public key
    date = CreateObject("roDateTime").AsSeconds()
    
    hashString = stri(date).Trim() + GetServiceCongfig().privateApiKey + GetServiceCongfig().publicApiKey
    
    ba = CreateObject("roByteArray")
    ba.FromAsciiString(hashString)
    
    digest = CreateObject("roEVPDigest")
    digest.Setup("md5")
    digest.Update(ba)
    
    return digest.Final()
end function

function GetCharacterMockData() as object
   return [{ 
        title: "A.I.M.",
        description: "AIM is a terrorist organization bent on destroying the world.",
        hdposterurl: "http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec.jpg" 
        },
        { 
        title: "Abomination",
        description: "Formerly known as Emil Blonsky, a spy of Soviet.",
        hdposterurl: "http://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04.jpg"
        },
        {
        title: "A-Bomb (HAS)",
        description: "Rick Jones has been Hulk's best bud ",
        hdposterurl: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg",
        },
        {
        title: "Agent X (Nijo)",
        description: "riginally a partner of the mind-altering assassin Black Swan",
        hdposterurl: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
        },
        {
        title: "Alex Wilder",
        description: "Despite being the only one of the Runaways",
        hdposterurl: "http://i.annihil.us/u/prod/marvel/i/mg/2/c0/4c00377144d5a.jpg",
        },
        {
        title: "Amun",
        description: "Amun is a ruthless teenage assassin, employed by the Sisterhood",
        hdposterurl: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
        }
        ]
    ' GetContentByDate("2023-01-01%2C2024-01-02", "2023-2024")
    ' GetContentByDate("2022-01-01%2C2023-01-02", "2022-2023")
    ' GetContentByDate("2021-01-01%2C2022-01-02", "2021-2022")
    end function

function GetComicList(dateRange as string, limit as integer) as String
    hash = generateServiceHash()
    ts = CreateObject("roDateTime").AsSeconds()
    ' ToD0: Create a proper web service which adheres to all of the potential search parameters
    feedURLComics = "https://gateway.marvel.com:443/v1/public/comics?format=comic&formatType=comic&orderBy=title"
    feedURLComics += "&limit=" + stri(limit).trim()
    feedURLComics += "&dateRange=" + dateRange
    feedURLComics += "&apikey=" + GetServiceCongfig().publicApiKey
    feedURLComics += "&ts=" + stri(ts).trim()
    feedURLComics += "&hash=" + hash
    
    if GetServiceCongfig().mockData
        feed = GetMockComicList(20)
    else
        url = CreateObject("roUrlTransfer")
        url.SetUrl(feedURLComics)
        url.SetCertificatesFile("common:/certs/ca-bundle.crt")
        url.AddHeader("Accept", "*/*")
        url.InitClientCertificates()
        feed = url.GetToString()
    end if
    
    return feed
end function

' Generate a random comic list
function GetMockComicList(limit as integer) as string
    json = ReadAsciiFile("pkg:/source/mockData/mockComics.json")
    comicList = ParseJson(json)
    
    elementCount = 0
    mockComicList = []
    
    for each comic in comicList.data.results
        if elementCount > limit exit for
       
        if Rnd(0) > 0.5 
            mockComicList.push(comic)
        end if
        elementCount++
    end for
    
    returnVal = {
        data: {
            results: mockComicList
            count: elementCount
        }
    }
    return formatjson(returnVal)
end function

function GetMockCharacterList() as string
    json = ReadAsciiFile("pkg:/source/mockData/mockCharacters.json")
end function

function GetContentByDate(dateRange as string, dateTitle as string) as Object
     
    feedURLComicDetails = "https://gateway.marvel.com:443/v1/public/comics/47396?apikey=225a6641c893e5d08a0db02a3ee4c4eb&ts=1713633226&hash=e0141e11d510b239c6b82a20af3a5083"
    feed =  GetComicList(dateRange, 10)
   
    if feed.Len() > 0
        json = ParseJson(feed)
        
        if json <> invalid and json.data <> invalid and json.data.count > 0
            rootChildren = {
               children: []
            }
            
            results = json.data.results
            
            children = []
            for each item in results
                   if item <> invalid
                        seasonArray = []
                        itemNode = CreateObject("roSGNode", "ContentNode")
                        
                        Utils_ForceSetFields(itemNode, {
                            hdPosterUrl: item.thumbnail.path + "." + item.thumbnail.extension
                            Description: item.description
                            id: item.id
                            Categories: item.format
                            title: item.title
                        })
                        
                        if GetServiceCongfig().mockData
                           json = ReadAsciiFile("pkg:/source/mockData/mockCharacters.json")
                        else
                            uri = item.characters.collectionURI + "?apikey=225a6641c893e5d08a0db02a3ee4c4eb&ts=1713633226&hash=e0141e11d510b239c6b82a20af3a5083"
                            url = CreateObject("roUrlTransfer")
                            url.SetUrl(uri)
                            url.SetCertificatesFile("common:/certs/ca-bundle.crt")
                            url.AddHeader("Accept", "*/*")
                            url.InitClientCertificates()
                            json = url.GetToString()
                        end if    
                            collection = ParseJson(json)
                                         
                            episodeArray = []
                            dropCount = 0
                            
                            if collection.data.count = 0
                                episodeNode = CreateObject("roSGNode", "ContentNode")
                                    episodeNode.SetFields({
                                            title: "N/A"
                                            url: GetServiceCongfig().mockPlayerUrl
                                            hdPosterUrl:  "pkg:/images/noimage.png"
                                            Description: "N/A"
                                        })
                                        dropCount++
                                      episodeArray.Push(episodeNode)  
                            end if
                            
                            for each character in collection.data.results
                                if GetServiceCongfig().mockData
                                    if len(character.name) > 0 and len(character.description) > 0 
                                        episodeNode = CreateObject("roSGNode", "ContentNode")
            
                                        episodeNode.SetFields({
                                            title: character.name
                                            url: GetServiceCongfig().mockPlayerUrl
                                            hdPosterUrl:  character.thumbnail.path + "." + character.thumbnail.extension
                                            Description: character.description
                                        })
            
                                        episodeArray.Push(episodeNode)
                                    else
                                        dropCount++
                                    end if
                                else
                                        episodeNode = CreateObject("roSGNode", "ContentNode")
                                        if len(character.name) > 0
                                            ? "Data"
                                            episodeNode.SetFields({
                                                title: character.name
                                                url: GetServiceCongfig().mockPlayerUrl
                                                hdPosterUrl:  character.thumbnail.path + "." + character.thumbnail.extension
                                                Description: character.description
                                            })
                                        else
                                            episodeNode.SetFields({
                                            title: "N/A"
                                            url: GetServiceCongfig().mockPlayerUrl
                                            hdPosterUrl:  "pkg:/images/noimage.png"
                                            Description: "N/A"
                                        })
                                        dropCount++
                                        end if
                                        episodeArray.Push(episodeNode)
                                 end if
                            end for
                            
                            seasonArray.Push(episodeArray)
                        
                        Utils_ForceSetFields(itemNode, { "seasons": seasonArray })
                    
                    children.Push(itemNode)
                end if
            end for
            
            return {
                        title: dateTitle
                        children: children
                    }
                    
        end if
    end if
end function