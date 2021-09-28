module CitableCollection
using CitableObject
using CiteEXchange
using CitableBase


import Base:  print
import Base:  show
import Base:  ==

import CitableBase: cex
import CitableBase: urn
import CitableBase: label


include("collection.jl")

export CitableObjectCollection 

end # module
