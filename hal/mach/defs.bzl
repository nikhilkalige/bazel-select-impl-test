"""Machine layer implementation details."""

# List of supported mach implementations
MACH_NAMES = [
    "jetson",
    "xavier",
]

MACH_LABELS = ["//hal/mach/{}" for name in MACH_NAMES]

def mach_info(sources, deps = None):
    return struct(
        srcs = sources,
        deps = deps if deps else None,
    )

def define_mach_config_settings(name):
    for name in MACH_NAMES:
        native.config_setting(
            name = name,
            flag_values = {
                "//images:mach": name,
            },
        )

def _create_machine_lib_impl(ctx):
    cc_infos = []
    runfiles = ctx.runfiles()

    for dep in ctx.attr.deps:
        cc_infos.append(dep[CcInfo])
        dep_runfile = dep[DefaultInfo].default_runfiles
        runfiles.merge(runfiles)

    merged_cc_info = cc_common.merge_cc_infos(cc_infos = cc_infos)

    return [
        DefaultInfo(files = depset(ctx.files.srcs), runfiles = runfiles),
        merged_cc_info,
    ]

create_machine_lib = rule(
    implementation = _create_machine_lib_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".h", ".cpp", ".hpp"], mandatory = True),
        "deps": attr.label_list(),
    },
    provides = [CcInfo, DefaultInfo],
)

def create_mach_implementation(name, **kwargs):
    for libname, mach_info in kwargs.items():
        create_machine_lib(
            name = libname,
            srcs = mach_info.srcs,
            deps = mach_info.deps,
            visibility = ["//visibility:public"],
        )
