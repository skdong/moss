local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'nova-api-backends-all-down',
    ['description'] = 'All API backends are down for nova-api',
    ['severity'] = 'down',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'haproxy_backend_servers',
          ['fields'] = {
            ['backend'] = 'nova-api',
            ['state'] = 'up',
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
  {
    ['name'] = 'nova-api-backends-majority-down',
    ['description'] = 'Less than 50% of backends are up for nova-api',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'haproxy_backend_servers_percent',
          ['fields'] = {
            ['backend'] = 'nova-api',
            ['state'] = 'up',
          },
          ['relational_operator'] = '<=',
          ['threshold'] = '50',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'last',
          ['group_by'] = {
          },
        },
      },
    },
  },
  {
    ['name'] = 'nova-api-backends-one-down',
    ['description'] = 'At least one API backend is down for nova-api',
    ['severity'] = 'warning',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'haproxy_backend_servers',
          ['fields'] = {
            ['backend'] = 'nova-api',
            ['state'] = 'down',
          },
          ['relational_operator'] = '>',
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
