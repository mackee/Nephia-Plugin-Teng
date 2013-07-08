### common config
+{
    appname => 'MyApp',
    'Plugin::Teng' => {
        dsn => 'DBI:SQLite:dbname=data.db',
        connect_level => 2,
        plugins => [qw/Lookup/],
    }
};
