@gbl = ->
  Meteor.isClient and window or global

@getConfigs = (name)->
  if not gbl()[name + 'Configs']
    gbl()[name + 'Configs'] = {}
  return gbl()[name + 'Configs']

@amIAdmin = ->
  _.contains(Meteor.user().roles, UserRoles.admin)

@checkOwner = (userId, doc)->
  userId == doc.owner or amIAdmin()

@canEdit = (doc)->
  doc.owner == Meteor.userId() or amIAdmin()

@cap = (str)->
  s.capitalize str

@plural = (str)->
  str + 's'

@pcap = (str)->
  plural cap str

@coln = (category)->
  gbl()[pcap category]

@getCountName = (category, category2, isMy)->
  countName = "#{category}Count"
  countName += '_' + category2 if category2
  countName += '_my' if isMy
  return countName

@getCommentCountName = (docId)->
  "#{docId}_CommentCount"

@myId = ->
  Meteor.userId()

@mySelf = ->
  Meteor.user()

@userById = (userId)->
  if userId == myId()
    mySelf()
  else
    Meteor.users.findOne {_id: userId}

@userProfile = (userId)->
  Profiles.findOne({owner: userId})

@imagesByCreator = (creator)->
  Images.find {creator: creator}

@firstImagesByCreator = (creator)->
  Images.findOne {creator: creator}

@imageUrl = (imageIdOrImage, store)->
  if typeof imageIdOrImage is 'string'
    image = Images.findOne {_id: imageIdOrImage}
  else
    image = imageIdOrImage
  return image?.url({store: store or 'images'}) or ''
