# ddcutil's autoconf doesn't recognize --disable-introspection passed by
# the gobject-introspection class inherited in the upstream recipe.
EXTRA_OECONF:remove = "--disable-introspection"
