local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'neutron-openvswitch-all-down',
    ['description'] = 'All Neutron openvswitch agents are down',
    ['severity'] = 'down',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_neutron_agents',
          ['fields'] = {
            ['service'] = 'openvswitch',
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
    ['name'] = 'neutron-openvswitch-majority-down',
    ['description'] = 'Less than 50% of Neutron openvswitch agents are up',
    ['severity'] = 'critical',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_neutron_agents_percent',
          ['fields'] = {
            ['service'] = 'openvswitch',
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
    ['name'] = 'neutron-openvswitch-one-down',
    ['description'] = 'At least one openvswitch agents is down',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'skip',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'openstack_neutron_agents',
          ['fields'] = {
            ['service'] = 'openvswitch',
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
