local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'keystone-response-time-duration',
    ['description'] = 'Keystone API is too slow',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_keystone_http_response_times',
          ['fields'] = {
            ['http_method'] = '== GET || == POST',
            ['http_status'] = '!= 5xx',
          },
          ['relational_operator'] = '>',
          ['threshold'] = '0.3',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'max',
          ['group_by'] = {
          },
        },
      },
    },
  },
}

return alarms
