local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'nova-api-local-endpoint',
    ['description'] = 'Nova API is locally down',
    ['severity'] = 'down',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_check_local_api',
          ['fields'] = {
            ['service'] = 'nova-api',
          },
          ['relational_operator'] = '==',
          ['threshold'] = '0',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'last',
          ['group_by'] = {
          },
        },
      },
    },
  },
}

return alarms
