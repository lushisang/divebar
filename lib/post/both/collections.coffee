@createPostCollection = (category, hasCategory2)->
  gbl()[pcap category] = new Meteor.Collection plural category

  moreSchema =
    category:
      type: String
      label: '分类'
      defaultValue: category

  if hasCategory2

    category2 = getConfigs(category).category2
    category2Default = getConfigs(category).category2Default
    category2Label = getConfigs(category).category2Label

    options = []
    _.each category2, (value)->
      options.push
        value: category2[value]
        label: category2Label[value]

    moreSchema.category2 =
      type: String
      label: '子分类'
      defaultValue: category2Default
      autoform:
        options: options

  coln(category).attachSchema new SimpleSchema [PostSchema, moreSchema]

@PostSchema = new SimpleSchema

  category:
    type: String
    label: '分类'
    defaultValue: 'post'

  owner:
    type: String
    label: '作者'
    regEx: SimpleSchema.RegEx.Id
    autoValue: ->
      if @isInsert
        Meteor.userId()
    autoform:
      options: ->
        _.map Meteor.users.find().fetch(), (user)->
          label: user.emails[0].address
          value: user._id

  createdAt:
    type: Date
    autoValue: ->
      if @isInsert
        new Date()

  updatedAt:
    type: Date
    optional:true
    autoValue: ->
      if @isUpdate
        new Date()

  title:
    type: String
    label: '标题'
    max: 100

  content:
    type: String
    label: '内容'
    optional: true
    max: 1000
    autoform:
      rows: 10

  date:
    type: Date
    label: '日期'
    autoValue: ->
      if @isInsert
        new Date()

  pictures:
    type: [String]
    label: '图片'
    optional: true

  creator:
    type: String
    label: '（开发辅助用）创建者标记'
