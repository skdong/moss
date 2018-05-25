logger = None

class Logger(object):

    def __getattr__(self, item):
        def func(*args, **kwargs):
            pass

        return func

try:
    import collectd
    logger = collectd
except:
    logger = Logger()
