local M = {}
setfenv(1, M) -- Remove external access to contain everything in the module

local alarms = {
  {
    ['name'] = 'other-fs-critical',
    ['description'] = 'The filesystem\'s free space is too low',
    ['severity'] = 'critical',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'fs_space_percent_free',
          ['fields'] = {
            ['fs'] = '!= /var/lib/nova && != /var/log && != /var/lib/mysql && != / && !~ ceph%-%d+$',
          },
          ['relational_operator'] = '<',
          ['threshold'] = '5',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'min',
          ['group_by'] = {
              fs,
          },
        },
      },
    },
  },
  {
    ['name'] = 'other-fs-warning',
    ['description'] = 'The filesystem\'s free space is low',
    ['severity'] = 'warning',
    ['no_data_policy'] = 'okay',
    ['trigger'] = {
      ['logical_operator'] = 'or',
      ['rules'] = {
        {
          ['metric'] = 'fs_space_percent_free',
          ['fields'] = {
            ['fs'] = '!= /var/lib/nova && != /var/log && != /var/lib/mysql && != / && !~ ceph%-%d+$',
          },
          ['relational_operator'] = '<',
          ['threshold'] = '10',
          ['window'] = '60',
          ['periods'] = '0',
          ['function'] = 'min',
          ['group_by'] = {
              fs,
          },
        },
      },
    },
  },
}

return alarms
