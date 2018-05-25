from abc import abstractmethod

class Plugin(object):

    @abstractmethod
    def collet(self, timestamp, pkt):
        pass

    @abstractmethod
    def report(self):
        pass
