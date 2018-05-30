local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'nova-cert-all-down',
    ['description'] = 'All Nova certs are down',
    ['severity'] = 'down',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_services',
          ['fields'] = {
            ['service'] = 'cert',
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
    ['name'] = 'nova-cert-majority-down',
    ['description'] = 'Less than 50% of Nova certs are up',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_services_percent',
          ['fields'] = {
            ['service'] = 'cert',
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
    ['name'] = 'nova-cert-one-down',
    ['description'] = 'At least one Nova cert is down',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_services',
          ['fields'] = {
            ['service'] = 'cert',
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
