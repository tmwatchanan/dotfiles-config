return {
    settings = {
        python = {
            pythonPath = require('config.python').get_python_path(),
            analysis = {
                autoImportCompletions = true,
                extraPaths = {
                    '/Users/watchanan.c/dev/airflow2-plugin',
                    '/Users/watchanan.c/dev/airflow_dags_for_ds/lib',
                },
            },
        },
    },
}
