return {
    settings = {
        python = {
            -- pythonPath = "/opt/homebrew/Caskroom/miniforge/base/bin/python",
            pythonPath = "/opt/homebrew/Caskroom/miniforge/base/envs/tm/bin/python",
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
