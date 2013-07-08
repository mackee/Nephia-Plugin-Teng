### common config
+{
    'Plugin::Teng' => {
        connect_info => [ 'DBI:SQLite:dbname=data.db' ],
        plugins => [qw/Lookup/],
    }
};
