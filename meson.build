# Project name, programming language and version
project (
    'ens-shell-gtk',
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
    ['--vapidir', join_paths (meson.current_source_dir (), 'subprojects', 'ens-shell-cli',  'vapi')],
    ['--vapidir', join_paths (meson.current_source_dir (), 'subprojects', 'ens-aw-core',  'vapi')],
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
    dependency ('gee-0.8'),
    dependency ('gobject-2.0'),
    dependency ('libvinject-0.0.0', fallback: ['libvinject', 'vinject_dep']),
    dependency ('ens-aw-core-0', fallback: ['ens-aw-core', 'ens_aw_core_dep']),
    dependency ('ens-shell-cli-0', fallback: ['ens-shell-cli', 'ens_shell_cli_dep']),
    meson.get_compiler ('c').find_library ('m', required : true)
]

datadir = get_option ('datadir')
subdir ('src')

# Define library
libens_shell_gtk = static_library (
    meson.project_name (),
    asresources,
    sources,
    dependencies: dependencies,
    install: true
)

subdir ('po')

ens_shell_gtk_dep = declare_dependency (
    dependencies: dependencies,
    include_directories: include_directories('.'),
    link_with: libens_shell_gtk
)


meson.add_install_script ('meson/post_install.py')
