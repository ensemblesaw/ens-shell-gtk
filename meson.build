# Project name, programming language and version
project (
    'com.github.ensemblesaw.gui-shell',
    'c', 'vala',
    version: '0.1.0',
    meson_version: '>=0.57.0'
)

# GNOME module
gnome = import ('gnome')

# Translation module
i18n = import ('i18n')

# Project arguments
add_project_arguments (
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name ()),
    '-DG_LOG_DOMAIN="Ensembles"',
    language: 'c'
)

add_project_arguments (
    ['--vapidir', join_paths (meson.current_source_dir (), 'vapi')],
    ['--vapidir', join_paths (meson.current_source_dir (), 'subprojects', 'ens-tui-shell',  'vapi')],
    language: 'vala'
)

# Compiling resources
asresources = gnome.compile_resources (
    'as-resources',
    'data/' + meson.project_name () + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

# Listing dependencies
dependencies = [
    dependency ('x11'),
    dependency ('granite-7'),
    dependency ('libadwaita-1'),
    dependency ('gtk4'),
    dependency ('glib-2.0'),
    dependency ('gobject-2.0'),
    dependency ('ens-aw-core-0', fallback: ['ens-aw-core', 'ens_aw_core_dep']),
    dependency ('ens-tui-shell-0', fallback: ['ens-tui-shell', 'ens_tui_shell_dep']),
    meson.get_compiler ('c').find_library ('m', required : true)
]

datadir = get_option ('datadir')
subdir ('src')

# Define shared library
static_library (
    meson.project_name (),
    asresources,
    sources,
    dependencies: dependencies,
    install: true
)

subdir ('po')

meson.add_install_script ('meson/post_install.py')
