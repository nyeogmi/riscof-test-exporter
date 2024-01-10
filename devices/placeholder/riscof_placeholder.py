from riscof.pluginTemplate import pluginTemplate

class placeholder(pluginTemplate):
    __model__ = "placeholder"

    __version__ = "0.0.0"

    def __init__(self, *args, **kwargs):
        sclass = super().__init__(*args, **kwargs)

        return sclass

    def initialise(self, suite, work_dir, archtest_env):
        pass

    def build(self, isa_yaml, platform_yaml):
        raise NotImplementedError("shouldn't be called")

    def runTests(self, testList, cgf_file=None):
        raise NotImplementedError("shouldn't be called")
