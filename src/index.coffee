'use strict'
debug = require('debug')('loopback:security:role:super')
adminRole = require './admin-role'

module.exports = (app, options) ->
  debug 'initializing component'
  loopback = app.loopback
  loopbackMajor = loopback and loopback.version and loopback.version.split('.')[0] or 1
  if loopbackMajor < 2
    throw new Error('loopback-component-role-super requires loopback 2.0 or newer')

  if !options or options.enabled isnt false
    adminRole(app, options)
  else
    debug 'component not enabled'
