load("//hal/mach:defs.bzl", "MACH_NAMES")

def _mach_transition_impl(settings, attr):
    return {"//images:mach": attr.mach}

mach_transition = transition(
    implementation = _mach_transition_impl,
    inputs = [],
    outputs = ["//images:mach"],
)

def _create_image_impl(ctx):
    return DefaultInfo(
        files = depset(ctx.files.applications),
    )

create_image = rule(
    implementation = _create_image_impl,
    cfg = mach_transition,
    attrs = {
        "applications": attr.label_list(mandatory = True, allow_files = True),
        "mach": attr.string(mandatory = True, values = MACH_NAMES),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)
