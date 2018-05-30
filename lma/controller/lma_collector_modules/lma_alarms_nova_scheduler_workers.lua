local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'nova-scheduler-all-down',
    ['description'] = 'All Nova schedulers are down',
    ['severity'] = 'down',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_services',
          ['fields'] = {
            ['service'] = 'scheduler',
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
    ['name'] = 'nova-scheduler-majority-down',
    ['description'] = 'Less than 50% of Nova schedulers are up',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_services_percent',
          ['fields'] = {
            ['service'] = 'scheduler',
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
    ['name'] = 'nova-scheduler-one-down',
    ['description'] = 'At least one Nova scheduler is down',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_nova_services',
          ['fields'] = {
            ['service'] = 'scheduler',
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
