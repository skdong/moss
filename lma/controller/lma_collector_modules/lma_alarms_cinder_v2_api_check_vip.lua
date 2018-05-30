local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'cinder-v2-api-check-failed',
    ['description'] = 'Endpoint check for cinder-v2-api is failed',
    ['severity'] = 'down',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_check_api',
          ['fields'] = {
            ['service'] = 'cinder-v2-api',
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
