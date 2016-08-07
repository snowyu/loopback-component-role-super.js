# Loopback Component superuser dynamic role

This loopback component add a new dynamic role: admin to become a super user.


### Installation

1. Install in you loopback project:

  `npm install --save loopback-component-role-super`

2. Create a component-config.json file in your server folder (if you don't already have one)

3. Configure options inside `component-config.json`:

  ```json
  {
    "loopback-component-role-admin": {
      "enabled": true,
      "role": "admin",
      "models": []
    }
  }
  ```
  - `enabled` *[Boolean]*: whether enable this component. *defaults: true*
  - `role` *[String]* : the role name. *defaults: $admin*
  - `models` *[Boolean|Array of string]*. *defaults: true*
    * enable the admin role to the models. `true` means all models in the app.models.
  - `isAdminUser` *[Function(aUserId, aRoleName, callback)]*: the callback function to check whether
    the `aUserId` is an admin user.
    * the `callback` function(err, result) the result should be a boolean.
    * *defaults: the Role should has `aRoleName` and the RoleMapping should has a user with `aUserId`.*

### Usage


Just enable it on `component-config.json`.

set `DEBUG=loopback:security:role:super` env vaiable to show debug info.


## History



