Promise     = require 'bluebird'
isArray     = require 'util-ex/lib/is/type/array'
debug       = require('debug')('loopback:security:role:super')

registerAdminRole = (Role, aRoleName, aIsAdminUserFn)->
  debug 'register role resolver: %s', aRoleName
  Role.registerResolver aRoleName, (role, context, done)->
    reject = (err)-> if err then done(err) else process.nextTick ->
      if done then done(null, false)
      return
    resolve = (result=true)->
      process.nextTick ->
        if done then done(null, result)
        return
    vUserId = context.getUserId()
    debug 'check the userId %s has the %s', vUserId, role
    unless vUserId
      reject()
    else
      aIsAdminUserFn vUserId, aRoleName, (err, result)->
        debug 'isAdminUser: %s', result
        if err then reject(err) else resolve(result)
        return
    return

isRoleIn = (aAcls, aRoleName)->
  for acl in aAcls
    return true if acl.principalType is 'ROLE' and acl.principalId is aRoleName
  return false

Role = null
RoleMapping = null
isAdminUserFn = (aUserId, aRoleName, done)->
  Role.findOne where: name: aRoleName
  .then (role)->
    RoleMapping.findOne
      where:
        principalId: aUserId
        roleId: role.id
  .then (roleMapping)->
    done(null, !!roleMapping)
    return
  .catch (err)->done(err)

module.exports = (aApp, aOptions) ->
  loopback = aApp.loopback
  Role = loopback.Role
  RoleMapping = loopback.RoleMapping
  vRoleName = (aOptions and aOptions.role) or '$admin'


  vIsAdminUser = (aOptions and aOptions.isAdminUserCallback) or isAdminUserFn
  vModels = (aOptions and aOptions.models)
  vModels = [] if vModels is false
  if isArray vModels
    vResult = {}
    for vName in vModels
      Model = aApp.models[vName]
      vResult[vName] = Model if Model
    vModels = vResult
  else
    vModels = aApp.models

  Role = aApp.models.Role
  registerAdminRole Role, vRoleName, vIsAdminUser

  for vName, Model of vModels
    vAcls = Model.settings.acls
    vAcls = Model.settings.acls = [] unless vAcls
    unless isRoleIn vAcls, vRoleName
      debug 'enable superuser for Model %s', vName
      vAcls.push
        principalType: 'ROLE'
        principalId: vRoleName
        permission: 'ALLOW'
  return
