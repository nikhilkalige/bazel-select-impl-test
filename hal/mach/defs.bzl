"""Machine layer implementation details."""

# List of supported mach implementations
MACH_NAMES = [
    "jetson",
    "xavier",
]

MACH_LABELS = ["//hal/mach/{}" for name in MACH_NAMES]

def define_mach_config_settings(name):
    for name in MACH_NAMES:
        native.config_setting(
            name = name,
            flag_values = {
                "//images:mach": name,
            },
        )

def create_mach_implementation(name, **kwargs):
    for libname, sources in kwargs.items():
        if type(sources) == "list":
            srcs = sources
        else:
            srcs = [sources]

        native.filegroup(
            name = libname,
            srcs = srcs,
            visibility = ["//visibility:public"],
        )
