return {
    settings = {
        python = {
            pythonPath = require('config.python').get_python_path(),
        },
        basedpyright = {
            typeCheckingMode = 'standard',
            disableOrganizeImports = true,
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
                extraPaths = {
                    '~/dev/airflow2-plugin/src',
                    '~/dev/airflow_dags_for_ds/lib',
                },
            },
        },
    },
}
