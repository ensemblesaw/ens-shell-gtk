# Install fonts
install_data (
    join_paths ('Fonts', 'Exo2', 'Exo2-VariableFont_wght.ttf'),
    install_dir: join_paths (get_option ('datadir'), 'fonts', 'truetype', 'Exo2')
)

install_data (
    join_paths ('Fonts', 'Exo2', 'Exo2-Italic-VariableFont_wght.ttf'),
    install_dir: join_paths (get_option ('datadir'), 'fonts', 'truetype', 'Exo2')
)

install_data (
    join_paths ('Fonts', 'Michroma', 'Michroma-Regular.ttf'),
    install_dir: join_paths (get_option ('datadir'), 'fonts', 'truetype', 'Michroma')
)

# Install Settings schema
schemas_conf = configuration_data()
schemas_conf.set('SCHEMA_ID', application_id)
schemas_conf.set('SCHEMA_PATH', schema_path)
schemas_conf.set('GETTEXT_PACKAGE', gettext_package)

configure_file(
    input: 'ens-shell-gtk.gschema.xml.in',
    output: application_id + '.gschema.xml',
    configuration: schemas_conf,
    install_dir: join_paths(datadir, 'glib-2.0', 'schemas')
)

# Compiling resources
gresource = gnome.compile_resources (
    'gresource',
    'ens-shell-gtk.gresource.xml',
    gresource_bundle: true,
    source_dir: [
        meson.current_build_dir(),
        meson.current_source_dir(),
    ],
    install: true,
    install_dir: get_option ('datadir') / meson.project_name () / 'resources'
)
