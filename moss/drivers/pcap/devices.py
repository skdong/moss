

class Devices(dict):

    def __getattr__(self, key):
        return self[key]

    def __setattr__(sekf, key, value):
        self[key] = value

    def report_device(self):
        metrics = list()
        for device in self.values():
           metrics.extend(device.report_packages())
        self._clean_dirty_devices()
        return metrics

    def _clean_dirty_devices(self):
        for device in self.values():
           if device.closed:
              self.pop(device.name)

    def _add_device(self, device):
        if device not in self.keys():
            self[device] = Device(device)

    def load_net_devices(self, devices):
        for key in self.keys():
           if key not in devices:
               self[key].close()
        for device in devices:
           self._add_device(device)

    def __str__(self):
        return '\n'.join(['%s: %s'%(k,v) for k,v in self.items()])

    def close(self):
        for device in self.values():
           device.close()

