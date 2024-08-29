return {
    "vinnymeller/swagger-preview.nvim",
    build = "npm install -g swagger-ui-watcher",
    enabled = false,
    opts = {
        port = 8000,
        host = "localhost",
    },
    cmd = { "SwaggerPreview", "SwaggerPreviewToggle" },
}
