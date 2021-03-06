local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'heat-api-http-errors',
    ['description'] = 'Too many 5xx HTTP errors have been detected on heat-api',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'haproxy_backend_response_5xx',
          ['fields'] = {
            ['backend'] = 'heat-api',
          },
          ['relational_operator'] = '>',
          ['threshold'] = '0',
          ['window'] = '60',
          ['periods'] = '1',
          ['function'] = 'diff',
          ['group_by'] = {
          },
        },
      },
    },
  },
}

return alarms
