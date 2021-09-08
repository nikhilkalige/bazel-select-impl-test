load("//hal/mach:defs.bzl", "MACH_NAMES")

def require_mach_implementation(name):
    conditions = {}
    for mach_name in MACH_NAMES:
        conditions["//hal/mach:%s" % mach_name] = ["//hal/mach/%s:%s" % (mach_name, name)]
    return select(conditions, no_match_error = "Unable to find mach implementation for '%s'" % name)
